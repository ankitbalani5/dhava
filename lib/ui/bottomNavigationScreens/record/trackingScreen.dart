
import 'dart:convert';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/mapSetting.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/saveActivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as img;

class TrackingScreen extends StatefulWidget {
  String categoryId;
  TrackingScreen(this.categoryId, {super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? mapController;
  List<LatLng> pathPoints = [];
  StreamSubscription<Position>? positionStream;
  double totalDistance = 0.0;
  DateTime? startTime;
  var startActivity = false;
  var start = false;
  var pause = false;
  Timer? _timer;
  Duration elapsed = Duration.zero;
  double avgPace = 0.0;
  int elevationGain = 0;
  int maxElevation = 0;
  double lastElevation = 0.0;
  int steps = 0;
  Stream<StepCount>? stepStream;
  String? runType;
  String address = '';
  String city = '';
  String state = '';
  String country = '';
  int initialSteps = 0;
  List<DateTime> pointTimestamps = [];

  String? categoryName;
  String _getCategoryName(String? categoryId) {
    if (Constant.getCategory == null ||
        Constant.getCategory!.data == null ||
        categoryId == null) return "Run"; // default text

    final category = Constant.getCategory!.data!
        .firstWhere(
          (item) => item.categoryId == categoryId,
      orElse: () => Constant.getCategory!.data!.first,
    );
    return category.categoryName ?? "Run";
  }



  @override
  void initState() {
    super.initState();
    runType = widget.categoryId;
    print('runtype::: $runType');

    initTracking();
    initStepTracking();
  }

  Future<void> initTracking() async {
    await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition();
    LatLng initial = LatLng(pos.latitude, pos.longitude);

    setState(() {
      pathPoints.add(initial);
      pointTimestamps.add(DateTime.now());
      startTime = DateTime.now();
    });

    // startLocationStream();
  }

  void initStepTracking() {
    stepStream = Pedometer.stepCountStream;
    stepStream?.listen((StepCount event) {
      if (initialSteps == 0) {
        initialSteps = event.steps;
      }
      setState(() {
        steps = event.steps - initialSteps;
      });
    }, onError: (error) {
      print("Step count error: $error");
    });
  }

  void startLocationStream() {
    positionStream?.cancel();
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // Lowered for better accuracy
      ),
    ).listen((position) {
      if (!pause && startActivity) {
      LatLng newPos = LatLng(position.latitude, position.longitude);

      double distance = 0.0;
      if (pathPoints.isNotEmpty) {
        distance += _calculateDistance(pathPoints.last, newPos);
      }


      // Ignore GPS noise below 3 meters
      if (distance > 3) {
        totalDistance += distance;

        setState(() {
          pathPoints.add(newPos);
          pointTimestamps.add(DateTime.now()); // <-- timestamp save
        });


        if (lastElevation != 0.0) {
          int diff = position.altitude.round() - lastElevation.round();

          // Ignore small fluctuations (<3m)
          if (diff > 3) {
            elevationGain += diff;
          }
        }


        lastElevation = position.altitude;
        if (position.altitude.round() > maxElevation) {
          maxElevation = position.altitude.round();
        }

        setState(() {
          pathPoints.add(newPos);
        });

      mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
      }
      }
    });
  }

  List<Map<String, dynamic>> calculateSplits() {
    List<Map<String, dynamic>> splits = [];
    double distanceCovered = 0.0;
    Duration splitDuration = Duration.zero;
    const double splitDistance = 1000.0; // 1km split

    LatLng? lastPoint;
    DateTime? lastTime;

    for (int i = 0; i < pathPoints.length; i++) {

      if (i >= pointTimestamps.length) break;

      if (lastPoint != null && lastTime != null) {
        double distance = _calculateDistance(lastPoint, pathPoints[i]);
        distanceCovered += distance;

        splitDuration += pointTimestamps[i].difference(lastTime);

        if (distanceCovered >= splitDistance) {
          double paceSec = splitDuration.inSeconds / (distanceCovered / 1000);
          splits.add({
            "split": splits.length + 1,
            "distance": (distanceCovered / 1000).toStringAsFixed(2),
            "pace": formatPace(paceSec),
            "time": "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}"
          });


          distanceCovered = 0.0;
          splitDuration = Duration.zero;
        }
      }
      lastPoint = pathPoints[i];
      lastTime = pointTimestamps[i];
    }


    if (distanceCovered > 0 && lastTime != null) {
      double paceSec = splitDuration.inSeconds / (distanceCovered / 1000);
      splits.add({
        "split": splits.length + 1,
        "distance": (distanceCovered / 1000).toStringAsFixed(2),
        "pace": formatPace(paceSec),
        "time": "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}"
      });
    }

    return splits;
  }

  Map<String, dynamic> calculateResults() {
    List<Map<String, dynamic>> splits = calculateSplits();
    double fastestSplit = double.infinity;
    if (splits.isNotEmpty) {
      for (var split in splits) {
        final pace = split['pace'];
        final parts = pace.split(':');
        final seconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
        if (seconds < fastestSplit) fastestSplit = seconds.toDouble();
      }
    } else {
      fastestSplit = 0.0;
    }

    double avgPace = elapsed.inSeconds > 0 && totalDistance > 0
        ? elapsed.inSeconds / (totalDistance / 1000) // seconds per km
        : 0.0;

    return {
      "totalDistance": totalDistance,
      "elapsedTime": elapsed.inSeconds,
      "fastestSplit": fastestSplit,
      "segments": splits.length,
      "splits": splits,
      'avgPace': avgPace
    };
  }

  Future<void> sendTrackingData() async {
    final url = Uri.parse("https://yourapi.com/save-activity");

    final results = calculateResults();

    final body = {
      "distance": results["totalDistance"],
      "time": results["elapsedTime"],
      "avgPace": results["avgPace"],
      "fastestSplit": results["fastestSplit"],
      "segments": results["segments"],
      "elevationGain": elevationGain,
      "maxElevation": maxElevation,
      "steps": steps,
      "path": pathPoints.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList(),
      "splits": results["splits"]
    };

    final response = await http.post(
      url,
      body: json.encode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print("✅ Data sent successfully");
    } else {
      print("❌ Error: ${response.body}");
    }
  }

  String formatPace(double paceInSec) {
    if (paceInSec.isInfinite || paceInSec.isNaN || paceInSec == 0) return "0:00";
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371000; // Earth radius in meters
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLng = _degToRad(end.longitude - start.longitude);
    double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
            cos(_degToRad(start.latitude)) *
                cos(_degToRad(end.latitude)) *
                sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (3.1415926535 / 180.0);

  void stopTracking() async {
    positionStream?.cancel();
    positionStream?.cancel();

    DateTime endTime = DateTime.now();
    double durationSeconds = endTime.difference(startTime!).inSeconds.toDouble();
    double averageSpeed = totalDistance / durationSeconds; // m/s

  }

  Set<Polyline> getPolyline() {
    return {
      Polyline(
        polylineId: const PolylineId("track"),
        color: Colors.blue,
        width: 5,
        points: pathPoints,
      )
    };
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  bool isShort = true;

  String getPace(double distance, double durationInSeconds) {
    if (distance <= 0) return "0:00";
    double paceInSec = durationInSeconds / (distance / 1000); //  per km
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    return "${min}:${sec.toString().padLeft(2, '0')}";
  }
  ScreenshotController screenshotController = ScreenshotController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Back press → Endurance tab
        bottomNavKey.currentState?.changeTab(2);
        Navigator.of(context).pop(); // Remove TrackingScreen
        return false; // prevent BottomNavBar onWillPop
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          title: isShort
              ? Text(
            'Tracking',
            style: CustomTextStyles.bold(),
          )
              : SizedBox(),
          leading: isShort
              ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
          )
              : SizedBox(),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: isShort
                  ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MapSetting()));
                  },
                  child: Icon(Icons.settings))
                  : GestureDetector(
                  onTap: () {
                    isShort = !isShort;
                    setState(() {});
                  },
                  child: Image.asset(AppImageOthers.expand2, height: 24)),
            )
          ],
        ),

        body: pathPoints.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : isShort ? Screenshot(
          controller: screenshotController,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pathPoints.first,
                      zoom: 17,

                    ),
                    polylines: getPolyline(),
                    myLocationEnabled: true,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                  Visibility(
                    visible: isShort,
                    child: Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          isShort = !isShort;
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 230,
                          // color: AppColor.textBackgroundGrey,
                          color: Colors.white,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(colors: [AppColor.bgRed.withOpacity(.5), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Run', style: CustomTextStyles.medium(fontSize: 18),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${elapsed.inMinutes.remainder(60)}m ",
                                                style: CustomTextStyles.regular(fontSize: 20)),
                                            Text("${elapsed.inSeconds.remainder(60)}s",
                                                style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.black)),
                                          ],
                                        ),
                                        Text('Time', style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(formatPace(avgPace),
                                            style: CustomTextStyles.bold(fontSize: 20)),
                                        Text('Split avg. pace (/km)',
                                            style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text((totalDistance / 1000).toStringAsFixed(2),
                                            style: CustomTextStyles.bold(fontSize: 20)),
                                        Text('Distance (km)',
                                            style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                SizedBox(height: isShort ? 80 : 80,
                                  child: isShort ? Column(children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          !start ? startWidget() : !pause ? pauseWidget() : resume()
                                        ],
                                      ),
                                    ],
                                  )
                                      : Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColor.bgRed
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(AppImageOthers.resume, height: 24),
                                                    SizedBox(width: 5,),
                                                    Text('Resume', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Colors.black
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(AppImageOthers.finish, height: 24,),
                                                    SizedBox(width: 5,),
                                                    Text('Finish', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white),)
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        )),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) : GestureDetector(
            onTap: () {
              isShort = !isShort;
              setState(() {

              });
            },
            child: expandTimeWidget()
        ),

      ),
    );
  }
 // selected runType ka naam/id store karne ke liye
  void _showRunTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Choose A Sport",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: Constant.getCategory?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = Constant.getCategory!.data![index];
                  final isSelected = runType == item.categoryId;
                  return ListTile(
                    leading: Image.network(
                      item.categoryIcon ?? "",
                      height: 28,
                      width: 28,
                      color: isSelected ? Colors.red : null,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ),
                    title: Text(
                      item.categoryName ?? "",
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.red)
                        : null,
                    onTap: () {
                      // ✅ main fix: parent setState call
                      setState(() {
                        runType = item.categoryId;
                        categoryName = item.categoryName;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String formatElapsed(Duration elapsed) {
    int hours = elapsed.inHours;
    int minutes = elapsed.inMinutes.remainder(60);
    int seconds = elapsed.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else {
      return "${minutes}m ${seconds}s";
    }
  }


  Widget startWidget(){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          GestureDetector(
              onTap: () => _showRunTypeBottomSheet(context),
              child: Image.asset(AppImageOthers.runType, height: 50,)),
          GestureDetector(
            onTap: () async {
              // showCongratulationDialog(context);

              start = true;
              startActivity = true;
              pause = false;

              startTime = DateTime.now();

              await getCurrentAddress();
              startLocationStream();
              startTimer(); // ⬅️ Start timer
              setState(() {

              });
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
            },
            child: SizedBox(height: 65,width: 65,
              child: Center(
                  child: SvgPicture.asset(AppImageSvg.play,height: 65,width: 65,)
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                isShort = !isShort;
                setState(() {

                });
              },
              child: Image.asset(AppImageOthers.expand, height: 50,)),
          SizedBox(),
        ],
      ),
    );
  }

  Future<void> getCurrentAddress() async {
    try {
      // Step 1: Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }

      // Step 2: Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print("📍 Lat: ${position.latitude}, Lng: ${position.longitude}");

      // Step 3: Reverse geocode
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        address = "${place.street}, ${place.subLocality}";
        city = place.locality ?? "";
        state = place.administrativeArea ?? "";
        country = place.country ?? "";

        print(" Address: $address, City: $city, State: $state, Country: $country");
      }
    } catch (e) {
      print(" Error getting location: $e");
    }
  }

  Widget pauseWidget(){
    return GestureDetector(
      onTap: () {
        // showCongratulationDialog(context);

        pause = true;
        setState(() {

        });
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
      },
      child:
      Container(
        height: 50,
        width: MediaQuery.of(context).size.width-60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.bgRed
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImageOthers.pause, height: 18),
            SizedBox(width: 5,),
            Text('Pause', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white),)
          ],
        ),
      ),
    );
  }

  Widget resume(){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 10),
          Expanded(
              child: GestureDetector(
                onTap: () {
                  pause = false;
                  startActivity = true;
                  startTimer();
                  setState(() {

                  });

                },
                child: Container(
                    height: 50,
                    // width: MediaQuery.of(context).size.width - 40,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.bgRed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImageOthers.resume, height: 24,),
                        SizedBox(width: 5,),
                        Text('Resume', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white),)
                      ],
                    ),
                  ),

              ),
          ),

          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {

                stopTracking();
                onFinishTracking();
              },
              child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImageOthers.finish, height: 24,),
                      SizedBox(width: 5,),
                      Text('Finish', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white),)
                    ],
                  ),
                ),

            ),
          ),

          SizedBox(width: 10),
        ],
      ),
    );
  }



  Future<void> onFinishTracking() async {
    if (pathPoints.isEmpty || pointTimestamps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No tracking data found!")),
      );
      return;
    }

    final results = calculateResults();

    final image = await screenshotController.capture();
    if (image != null) {
      final screenShotImg = img.decodeImage(image);

      if (screenShotImg != null) {
        final fullWidth = screenShotImg.width;
        final fullHeight = screenShotImg.height;

        const topOffset = 150; // pixels to skip from top (e.g. remove appbar/padding)
        const bottomSheetHeight = 450; // pixels to cut from bottom

        // Remaining height after cutting top + bottom
        final cropHeight = (fullHeight - topOffset - bottomSheetHeight)
            .clamp(0, fullHeight)
            .toInt();

        final cropped = img.copyCrop(
          screenShotImg,
          x: 0,
          y: topOffset, // skip upper part
          width: fullWidth,
          height: cropHeight,
        );

        final croppedBytes = img.encodePng(cropped);
        final base64Image = base64Encode(croppedBytes);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaveActivity(
              trackingData: {
                "runType": runType,
                "distance": results["totalDistance"],
                "time": results["elapsedTime"],
                "avgPace": results["avgPace"],
                "fastestSplit": results["fastestSplit"],
                "segments": results["segments"],
                "splits": results["splits"],
                "elevationGain": elevationGain,
                "maxElevation": maxElevation,
                "steps": steps,
                "path": pathPoints
                    .map((p) => {"lat": p.latitude, "lng": p.longitude})
                    .toList(),
                "photo": base64Image,
                "city": city,
                "state": state,
                "country": country,
                "address": address,
              },
            ),
          ),
        );
      }
    }
  }





  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!pause && startActivity) {
        setState(() {
          elapsed = Duration(seconds: elapsed.inSeconds + 1);
          if (totalDistance > 50) {
            avgPace = elapsed.inSeconds / (totalDistance / 1000); // sec/km
          } else {
            avgPace = 0.0;
          }
        });
      }
    });
  }


  // Widget expandTimeWidget({
  //   required Duration elapsed,
  //   required double distance,          // meters
  //   required double avgPace,           // seconds per km
  //   required double elevationGain,required List<double> graphData,}){
  //   return Container(
  //     width: double.infinity,
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text('Time', style: CustomTextStyles.semiBold()),
  //         Text(
  //             formatElapsed(elapsed), style: CustomTextStyles.bold(fontSize: 80),),
  //         Divider(),
  //         Text('AVG PACE', style: CustomTextStyles.semiBold()),
  //         Text(formatPace(avgPace), style: CustomTextStyles.bold(fontSize: 100),),
  //         Text('/KM', style: CustomTextStyles.semiBold()),
  //         Divider(),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   height: 80,
  //                   width: 50,
  //                   color: Colors.blue,
  //                 ),
  //                 Text('0:00', style: CustomTextStyles.semiBold()),
  //               ],
  //             ),
  //
  //             SizedBox(
  //               height: 200,
  //               child: VerticalDivider(
  //                 thickness: 1,
  //                 color: Colors.grey,
  //                 // width: 20,
  //               ),
  //             ),
  //             Column(
  //               children: [
  //                 Text('DISTANCE', style: CustomTextStyles.semiBold()),
  //                 Text("${(distance / 1000).toStringAsFixed(2)}", style: CustomTextStyles.bold(fontSize: 70),),
  //                 Text('KILOMETERS', style: CustomTextStyles.semiBold()),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget expandTimeWidget({
    required Duration elapsed,
    required double distance,          // meters
    required double avgPace,           // seconds per km
    required double elevationGain,
    required List<double> graphData,   // pace over time
  }) {
    // Ensure graph data is safe (no NaN or Infinity values)
    final safeGraphData = graphData.isNotEmpty
        ? graphData.map((e) => e.isFinite ? e : 0.0).toList()
        : [0.0]; // fallback if empty

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Time', style: CustomTextStyles.semiBold()),
          Text(
            formatElapsed(elapsed),
            style: CustomTextStyles.bold(fontSize: 80),
          ),
          Divider(),
          Text('AVG PACE', style: CustomTextStyles.semiBold()),
          Text(
            formatPace(avgPace),
            style: CustomTextStyles.bold(fontSize: 100),
          ),
          Text('/KM', style: CustomTextStyles.semiBold()),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dynamic Pace Graph
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      height: 150,
                      width: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                safeGraphData.length,
                                    (index) => FlSpot(index.toDouble(), safeGraphData[index]),
                              ),
                              isCurved: true,
                              barWidth: 2,
                              color: Colors.red,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Small reference box
                  Container(
                    height: 80,
                    width: 50,
                    color: Colors.blue,
                  ),
                  Text('0:00', style: CustomTextStyles.semiBold()),
                ],
              ),

              // Divider
              SizedBox(
                height: 200,
                child: VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),

              // Distance display
              Column(
                children: [
                  Text('DISTANCE', style: CustomTextStyles.semiBold()),
                  Text(
                    "${(distance / 1000).toStringAsFixed(2)}",
                    style: CustomTextStyles.bold(fontSize: 70),
                  ),
                  Text('KILOMETERS', style: CustomTextStyles.semiBold()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  // Widget expandTimeWidget({required Duration elapsed, required double distance,}) {
  //   return Container(
  //     width: double.infinity,
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         /// TIME
  //         Text('Time', style: CustomTextStyles.semiBold()),
  //         Text(
  //           formatElapsed(elapsed),
  //           style: CustomTextStyles.bold(fontSize: 40),
  //         ),
  //         Divider(),
  //
  //         /// AVG PACE
  //         Text('AVG PACE', style: CustomTextStyles.semiBold()),
  //         Text(
  //           formatPace(avgPace),
  //           style: CustomTextStyles.bold(fontSize: 70),
  //         ),
  //         Text('/KM', style: CustomTextStyles.semiBold()),
  //         Divider(),
  //
  //         /// DISTANCE + ELEVATION
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.terrain, color: Colors.blue, size: 40),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   "${elevationGain.toStringAsFixed(0)} m",
  //                   style: CustomTextStyles.semiBold(),
  //                 ),
  //                 Text("Elevation", style: CustomTextStyles.regular(fontSize: 12)),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 120,
  //               child: VerticalDivider(thickness: 1, color: Colors.grey),
  //             ),
  //             Column(
  //               children: [
  //                 Text('DISTANCE', style: CustomTextStyles.semiBold()),
  //                 Text(
  //                   "${(distance / 1000).toStringAsFixed(2)}",
  //                   style: CustomTextStyles.bold(fontSize: 50),
  //                 ),
  //                 Text('Kilometers', style: CustomTextStyles.semiBold()),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Divider(),
  //
  //         /// GRAPH (PACE/ELEVATION OVER DISTANCE)
  //         // SizedBox(
  //         //   height: 200,
  //         //   child: Padding(
  //         //     padding: const EdgeInsets.all(8.0),
  //         //     child: LineChart(
  //         //       LineChartData(
  //         //         gridData: FlGridData(show: true),
  //         //         titlesData: FlTitlesData(
  //         //           leftTitles: AxisTitles(
  //         //             sideTitles: SideTitles(showTitles: true, reservedSize: 40),
  //         //           ),
  //         //           bottomTitles: AxisTitles(
  //         //             sideTitles: SideTitles(showTitles: true),
  //         //           ),
  //         //         ),
  //         //         borderData: FlBorderData(show: true),
  //         //         lineBarsData: [
  //         //           LineChartBarData(
  //         //             spots: List.generate(
  //         //               graphData.length,
  //         //                   (i) => FlSpot(i.toDouble(), graphData[i]),
  //         //             ),
  //         //             isCurved: true,
  //         //             color: Colors.blue,
  //         //             dotData: FlDotData(show: false),
  //         //             belowBarData: BarAreaData(show: false),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

}


