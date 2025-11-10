
import 'dart:convert';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart' show bottomNavKey;
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
  String categoryName;
  String categoryIcon;
  TrackingScreen(this.categoryId, this.categoryName, this.categoryIcon, {super.key});

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
  bool isShort = true;
  ScreenshotController screenshotController = ScreenshotController();
  String? categoryName;
  String? categoryIcon;
  List<double> altitudeList = [];
  var pace_str;
  var split_str;
  var elevation_str;
  var split_string;
  double totalDistanceMetersSoFar = 0.0;

  @override
  void initState() {
    super.initState();
    runType = widget.categoryId;
    print('runtype::: $runType');

    categoryName = widget.categoryName;
    categoryIcon = widget.categoryIcon;
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
          altitudeList.add(position.altitude);
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

  List<Map<String, dynamic>> calculateSplits() {
    List<Map<String, dynamic>> splits = [];
    List<String> paceArr = [];
    List<String> splitArr = [];
    List<String> elevationArr = [];

    if (pathPoints.length < 2 || pointTimestamps.length < 2) {
      print("⚠️ Not enough data to calculate splits");
      return splits;
    }

    // 🔹 Step 1: Calculate total distance
    double totalDistanceMeters = 0.0;
    for (int i = 1; i < pathPoints.length; i++) {
      totalDistanceMeters += _calculateDistance(pathPoints[i - 1], pathPoints[i]);
    }

    // 🔹 Step 2: Adaptive split interval
    double splitInterval = 20.0;

    print("📏 Total Distance: ${totalDistanceMeters.toStringAsFixed(2)} m");
    print("📍 Using Split Interval: $splitInterval m");

    // 🔹 Step 3: Loop for split calculation
    double accumulatedDistance = 0.0;
    int splitStartIndex = 0;
    int splitCount = 1;
    double elevationGain = 0.0;

    for (int i = 1; i < pathPoints.length; i++) {
      if (i >= pointTimestamps.length) break;

      double segmentDistance = _calculateDistance(pathPoints[i - 1], pathPoints[i]);
      accumulatedDistance += segmentDistance;

      print("🧭 Segment #$i → segment: ${segmentDistance.toStringAsFixed(2)} m, "
          "accumulated: ${accumulatedDistance.toStringAsFixed(2)} m");


      // 🏔 Elevation difference (if altitude list or property available)
      double currentAltitude = (altitudeList.isNotEmpty && i < altitudeList.length)
          ? altitudeList[i]
          : 0.0;
      double previousAltitude = (altitudeList.isNotEmpty && i - 1 < altitudeList.length)
          ? altitudeList[i - 1]
          : 0.0;

      double elevationDiff = currentAltitude - previousAltitude;
      if (elevationDiff > 0) elevationGain += elevationDiff; // only count gain


      // ✅ जब split पूरा हो जाए या आखिरी पॉइंट हो
      if (accumulatedDistance >= splitInterval || i == pathPoints.length - 1) {
        Duration splitDuration =
        pointTimestamps[i].difference(pointTimestamps[splitStartIndex]);

        // 🕒 pace calculation
        double paceSecPerKm = (accumulatedDistance > 0)
            ? splitDuration.inSeconds / (accumulatedDistance / 1000)
            : 0;

        String paceStr = (paceSecPerKm.isFinite && paceSecPerKm > 0)
            ? formatPace(paceSecPerKm)
            : "0:00";

        // String distanceStr = (accumulatedDistance / 1000).toStringAsFixed(2);
        totalDistanceMetersSoFar += accumulatedDistance;
        String distanceStr = (totalDistanceMetersSoFar / 1000).toStringAsFixed(2);

        String timeStr =
            "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}";

        splits.add({
          "split": splitCount,
          "distance": distanceStr,
          "pace": paceStr,
          "time": timeStr,
          "elevation": elevationGain.toStringAsFixed(1),
        });

        // 🔹 Update running total distance here
        // totalDistanceMetersSoFar += accumulatedDistance;

        // 🔹 Arrays for backend
        paceArr.add(paceStr);
        splitArr.add(distanceStr);
        elevationArr.add(elevationGain.toStringAsFixed(1));

        print("✅ Split #$splitCount => "
            "Distance: $distanceStr km | Pace: $paceStr | Time: $timeStr");

        // Reset for next split
        splitCount++;
        splitStartIndex = i;
        accumulatedDistance = 0.0;
        elevationGain = 0.0;
      }
    }

    // 🔹 Convert to comma-separated strings
    pace_str = paceArr.join(',');
    split_str = splitArr.join(',');
    elevation_str = elevationArr.join(',');

// 🔹 Convert full splits data into comma-separated JSON-like string
    String formattedSplits = splits.map((s) {
      return """{
      "split": ${s['split']},
      "distance": "${s['distance']}",
      "pace": "${s['pace']}",
      "time": "${s['time']}",
      "elevation": "${s['elevation']}"
    }""";
    }).join(",\n");

    print("🏁 pace_str => $pace_str");
    print("🏁 split_str => $split_str");
    print("🏁 elevation_str => $elevation_str");
    print("🏁 splits_string => $formattedSplits");

// Store for trackingData use
    split_string = formattedSplits;
    print('split_string:::${split_string}');

    // ✅ Cross-check final distance
    print("✅ Final total from splits: ${(totalDistanceMetersSoFar / 1000).toStringAsFixed(2)} km");

    return splits;
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
        color: AppColor.bgRed/*Colors.blue*/,
        width: 5,
        points: pathPoints,
      )
    };
  }

  String getPace(double distance, double durationInSeconds) {
    if (distance <= 0) return "0:00";
    double paceInSec = durationInSeconds / (distance / 1000); //  per km
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    return "${min}:${sec.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _showStopTrackingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to stop tracking and exit?',
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                stopTracking(); // <-- Call your stop tracking function
                bottomNavKey.currentState?.changeTab(2);
                Navigator.of(context).pop(); // close dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Back press → Endurance tab
        print('current State from tracking:::${bottomNavKey.currentState?.currentTap}');


        if (start == true) {
          await _showStopTrackingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
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
              // Navigator.pop(context);
              if (start == true) {
                _showStopTrackingDialog(context);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
          )
              : SizedBox(),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: isShort
                  ? SizedBox()/*GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MapSetting()));
                  },
                  child: Icon(Icons.settings))*/
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
            : Stack(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: GoogleMap(
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
                ),
                Visibility(
                  visible: !isShort,
                  child: Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: !isShort ? 150 : 220,
                      child: expandTimeWidget(elapsed: elapsed, distance: totalDistance)
                  ),
                ),
                Positioned(
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
                      height: !isShort ? 150 : 220,
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
                            Text(categoryName.toString(), style: CustomTextStyles.medium(fontSize: 18),),
                            Visibility(
                              visible: isShort,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${elapsed.inMinutes.remainder(60)}m ",
                                              style: CustomTextStyles.regular(fontSize: 26)),
                                          Text("${elapsed.inSeconds.remainder(60)}s",
                                              style: CustomTextStyles.regular(fontSize: 20, textColor: Colors.black)),
                                        ],
                                      ),
                                      Text('Time', style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(formatPace(avgPace),
                                          style: CustomTextStyles.bold(fontSize: 26)),
                                      Text('Split avg. pace (/km)',
                                          style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text((totalDistance / 1000).toStringAsFixed(2),
                                          style: CustomTextStyles.bold(fontSize: 26)),
                                      Text('Distance (km)',
                                          style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),

                            bottomButton()

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

      ),
    );
  }

  Widget bottomButton(){
    return SizedBox(height: isShort ? 70 : 70,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              !start ? startWidget() : !pause ? pauseWidget() : resume()
            ],
          ),
        ],
        )
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
                        categoryIcon = item.categoryIcon;
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
              child: Container(
                height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: AppColor.bgRed,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(categoryIcon!, height: 25, color: AppColor.bgRed,),
                  ))), //AppImageOthers.runType
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
            child: SizedBox(height: 60,width: 60,
              child: Center(
                  child: SvgPicture.asset(AppImageSvg.play,height: 60,width: 60,)
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
                    padding: EdgeInsets.all(12),
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

        final trackingData = {
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
          "pace_str": pace_str,
          "split_str": split_string,
          "elavation_str": elevation_str,
          "path": pathPoints
              .map((p) => {"latitude": p.latitude.toString(), "longitude": p.longitude.toString()})
              .toList(),
          "photo": base64Image,
          "city": city,
          "state": state,
          "country": country,
          "address": address,
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaveActivity(
              trackingData: trackingData
            ),
          ),
        );
        // OR for pretty (readable) formatting:
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        print(encoder.convert(trackingData));
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


  Widget expandTimeWidget({required Duration elapsed, required double distance,}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// TIME
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Time', style: CustomTextStyles.semiBold()),
                Text(
                  formatElapsed(elapsed),
                  style: CustomTextStyles.bold(fontSize: 40),
                ),
              ],
            ),
          ),

          Divider(),

          /// AVG PACE
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('AVG PACE', style: CustomTextStyles.semiBold()),
                Text(
                  formatPace(avgPace),
                  style: CustomTextStyles.bold(fontSize: 70),
                ),
                Text('/KM', style: CustomTextStyles.semiBold()),
              ],
            ),
          ),
          Divider(),

          /// DISTANCE + ELEVATION
          Expanded(
            child: IntrinsicHeight( // 👈 Added this wrapper
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// ELEVATION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.terrain, color: Colors.blue, size: 40),
                      SizedBox(height: 8),
                      Text(
                        "${elevationGain.toStringAsFixed(0)} m",
                        style: CustomTextStyles.semiBold(),
                      ),
                      Text("Elevation", style: CustomTextStyles.regular(fontSize: 12)),
                    ],
                  ),

                  /// 👇 Vertical Divider (Now dynamic)
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.grey,
                    width: 20,
                  ),

                  /// DISTANCE
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('DISTANCE', style: CustomTextStyles.semiBold()),
                      Text(
                        "${(distance / 1000).toStringAsFixed(2)}",
                        style: CustomTextStyles.bold(fontSize: 50),
                      ),
                      Text('Kilometers', style: CustomTextStyles.semiBold()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
