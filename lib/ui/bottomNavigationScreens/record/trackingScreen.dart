
import 'dart:convert';

import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/saveActivity.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coherent_endurance/constant/constant.dart';

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import '../../../data/localDBModel/WorkoutModel.dart';
import '../../defaultScreen/defaultScreen.dart';
import '../mapSetting.dart';


class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

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
  double elevationGain = 0.0;
  double maxElevation = 0.0;
  double lastElevation = 0.0;
  int steps = 0;
  Stream<StepCount>? stepStream;



  @override
  void initState() {
    super.initState();
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

  // void initStepTracking() {
  //   stepStream = Pedometer.stepCountStream;
  //   stepStream?.listen((StepCount event) {
  //     setState(() {
  //       steps = event.steps;
  //     });
  //   }, onError: (error) {
  //     print("Step count error: $error");
  //   });
  // }

  int initialSteps = 0;
  List<DateTime> pointTimestamps = [];

  void initStepTracking() {
    stepStream = Pedometer.stepCountStream;
    stepStream?.listen((StepCount event) {
      if (initialSteps == 0) {
        initialSteps = event.steps; // पहली बार का step count save करो
      }
      setState(() {
        steps = event.steps - initialSteps; // session-based steps
      });
    }, onError: (error) {
      print("Step count error: $error");
    });
  }



  // void startLocationStream() {
  //   positionStream = Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.bestForNavigation,
  //       distanceFilter: 10,
  //     ),
  //   ).listen((position) {
  //     LatLng newPos = LatLng(position.latitude, position.longitude);
  //     if (pathPoints.isNotEmpty) {
  //       totalDistance += _calculateDistance(pathPoints.last, newPos);
  //     }
  //
  //     setState(() {
  //       pathPoints.add(newPos);
  //     });
  //
  //     mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
  //   });
  // }

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

        // ✅ Smoothed Elevation Calculation (Strava Style)
        if (lastElevation != 0.0) {
          double diff = position.altitude - lastElevation;

          // Ignore small fluctuations (<3m)
          if (diff > 3) {
            elevationGain += diff;
          }
        }

        // ✅ Update lastElevation & maxElevation
        lastElevation = position.altitude;
        if (position.altitude > maxElevation) {
          maxElevation = position.altitude;
        }
        
        // // Calculate Elevation Gain
        // if (position.altitude > lastElevation) {
        //   elevationGain += (position.altitude - lastElevation);
        // }
        // lastElevation = position.altitude;
        //
        // // Max Elevation Check
        // if (position.altitude > maxElevation) {
        //   maxElevation = position.altitude;
        // }

        setState(() {
          pathPoints.add(newPos);
        });
      // setState(() {
      //   pathPoints.add(newPos);
      // });

      mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
      }
      }
    });
  }

  // List<Map<String, dynamic>> calculateSplits() {
  //   List<Map<String, dynamic>> splits = [];
  //   double distanceCovered = 0.0;
  //   Duration splitDuration = Duration.zero;
  //   double splitDistance = 1000.0; // 1km split
  //
  //   LatLng? lastPoint;
  //   DateTime? lastTime = startTime;
  //
  //   for (int i = 0; i < pathPoints.length; i++) {
  //     if (lastPoint != null && lastTime != null) {
  //       double distance = _calculateDistance(lastPoint, pathPoints[i]);
  //       distanceCovered += distance;
  //       Duration duration = DateTime.now().difference(lastTime);
  //       splitDuration += duration;
  //
  //       if (distanceCovered >= splitDistance) {
  //         // Pace = seconds per km
  //         double paceSec = splitDuration.inSeconds / (distanceCovered / 1000);
  //         splits.add({
  //           "split": splits.length + 1,
  //           "distance": (distanceCovered / 1000).toStringAsFixed(2),
  //           "pace": formatPace(paceSec),
  //           "time": "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}"
  //         });
  //
  //         // Reset for next split
  //         distanceCovered = 0.0;
  //         splitDuration = Duration.zero;
  //       }
  //     }
  //     lastPoint = pathPoints[i];
  //     lastTime = DateTime.now();
  //   }
  //   return splits;
  // }
  List<Map<String, dynamic>> calculateSplits() {
    List<Map<String, dynamic>> splits = [];
    double distanceCovered = 0.0;
    Duration splitDuration = Duration.zero;
    const double splitDistance = 1000.0; // 1km split

    LatLng? lastPoint;
    DateTime? lastTime;

    for (int i = 0; i < pathPoints.length; i++) {
      // ✅ अगर timestamp missing है, तो skip कर दो
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

          // Reset for next split
          distanceCovered = 0.0;
          splitDuration = Duration.zero;
        }
      }
      lastPoint = pathPoints[i];
      lastTime = pointTimestamps[i];
    }

    // ✅ अगर आखिरी में बचा हुआ distance < 1km है, तो भी add करो
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

    // Get fastest split pace
    String fastestSplitPace = "0:00";
    if (splits.isNotEmpty) {
      double fastest = double.infinity;
      for (var split in splits) {
        final pace = split['pace'];
        final parts = pace.split(':');
        final seconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
        if (seconds < fastest) fastest = double.parse(seconds.toString());
      }
      fastestSplitPace = formatPace(fastest);
    }

    return {
      "totalDistance": (totalDistance / 1000).toStringAsFixed(2),
      "elapsedTime": elapsed.inSeconds,
      "avgPace": formatPace(avgPace),
      "fastestSplit": fastestSplitPace,
      "segments": splits.length,
      "splits": splits,
    };
  }


  // Future<void> sendTrackingData() async {
  //   final url = Uri.parse("https://yourapi.com/save-activity");
  //   final body = {
  //     "distance": /*totalDistance*/(totalDistance / 1000).toStringAsFixed(2),
  //     "time": elapsed.inSeconds,
  //     "avgPace": /*avgPace*/formatPace(avgPace),
  //     "elevationGain": elevationGain,
  //     "maxElevation": maxElevation,
  //     "steps": steps,
  //     "path": pathPoints.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList(),
  //   };
  //
  //   final response = await http.post(url,
  //     body: json.encode(body),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("Data sent successfully");
  //   } else {
  //     print("Error: ${response.body}");
  //   }
  // }

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
    if (paceInSec.isInfinite || paceInSec.isNaN) return "0:00";
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
    // start = false;
    // pause = false;
    // startActivity = false;

    DateTime endTime = DateTime.now();
    double durationSeconds = endTime.difference(startTime!).inSeconds.toDouble();
    double averageSpeed = totalDistance / durationSeconds; // m/s

    // final workout = WorkoutModel(
    //   path: pathPoints,
    //   totalDistance: totalDistance,
    //   averageSpeed: averageSpeed,
    //   startTime: startTime!,
    //   endTime: endTime,
    // );
    //
    // final box = Hive.box<WorkoutModel>('workouts');
    // await box.add(workout);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Workout saved!")),
    // );
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
    double paceInSec = durationInSeconds / (distance / 1000); // seconds per km
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    return "${min}:${sec.toString().padLeft(2, '0')}";
  }
  ScreenshotController screenshotController = ScreenshotController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: isShort ? Text('Tracking', style: CustomTextStyles.bold(),) : SizedBox(),
        leading: isShort ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black,)) : SizedBox(),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: isShort ? GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapSetting()));
                },
                child: Icon(Icons.settings)) : GestureDetector(
                onTap: () {
                  isShort = !isShort;
                  setState(() {

                  });
                },
                child: Image.asset(AppImageOthers.expand2, height: 24,)),
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
                        height: 155,
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
                              Text('Run', style: CustomTextStyles.medium(fontSize: 16),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${elapsed.inMinutes.remainder(60)}m ",
                                              style: CustomTextStyles.regular(fontSize: 25)),
                                          Text("${elapsed.inSeconds.remainder(60)}s",
                                              style: CustomTextStyles.regular(fontSize: 18, textColor: Colors.black)),
                                        ],
                                      ),
                                      Text('Time', style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(formatPace(avgPace),
                                          style: CustomTextStyles.bold(fontSize: 25)),
                                      Text('Split avg. pace (/km)',
                                          style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text((totalDistance / 1000).toStringAsFixed(2),
                                          style: CustomTextStyles.bold(fontSize: 25)),
                                      Text('Distance (km)',
                                          style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Column(
                              //       children: [
                              //         Text("${elevationGain.toStringAsFixed(1)} m",
                              //             style: CustomTextStyles.bold(fontSize: 22)),
                              //         Text("Elevation Gain", style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                              //       ],
                              //     ),
                              //     Column(
                              //       children: [
                              //         Text("${maxElevation.toStringAsFixed(1)} m",
                              //             style: CustomTextStyles.bold(fontSize: 22)),
                              //         Text("Max Elevation", style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                              //       ],
                              //     ),
                              //     Column(
                              //       children: [
                              //         Text("$steps", style: CustomTextStyles.bold(fontSize: 22)),
                              //         Text("Steps", style: CustomTextStyles.medium(fontSize: 12, textColor: Colors.grey)),
                              //       ],
                              //     ),
                              //
                              //   ],
                              // ),
                              SizedBox(height: 10,)
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
      bottomNavigationBar: SizedBox(
        height: isShort ? 70 : 70,
        child: isShort ? Column(
          children: [
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
          height: 60,
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  height: 60,
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
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  height: 60,
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
              // SizedBox(),
              // SvgPicture.asset(AppImageSvg.pause),
              // SvgPicture.asset(AppImageSvg.map),
              // SizedBox()
            ],
          )),
        ),
      ),
    );
  }



  Widget startWidget(){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          Image.asset(AppImageOthers.runType, height: 50,),
          GestureDetector(
            onTap: () {
              // showCongratulationDialog(context);

              start = true;
              startActivity = true;
              pause = false;

              startTime = DateTime.now();
              startLocationStream();
              startTimer(); // ⬅️ Start timer
              setState(() {

              });
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
            },
            child: Container(
              height: 60,
              child: Center(
                  child: SvgPicture.asset(AppImageSvg.play)
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
        height: 60,
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
      ),/*Container(
        height: 60,
        child: Center(child: SvgPicture.asset(AppImageSvg.pause)),
      ),*/
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
                  // showCongratulationDialog(context);

                  pause = false;
                  startActivity = true;
                  startTimer();
                  setState(() {

                  });
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
                },
                child: Container(
                    height: 60,
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
                /*Container(
              height: 60,
              child: Center(
                  child: Image.asset(AppImageOthers.resume, color: Colors.white,)
              ),
            ),*/
              ),
          ),

          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // showCongratulationDialog(context);

                // startActivity = true;
                // setState(() {
                //
                // });
                stopTracking();
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
                // sendTrackingData();
                onFinishTracking();
              },
              child: Container(
                  height: 60,
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
              /*Container(
              height: 60,
              child: Center(child: Image.asset(AppImageOthers.finish, color: Colors.white,)),
            ),*/
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SaveActivity(
                trackingData: {
                  "distance": results["totalDistance"],
                  "time": results["elapsedTime"],
                  "avgPace": results["avgPace"],
                  "fastestSplit": results["fastestSplit"],
                  "segments": results["segments"],
                  "splits": results["splits"],
                  "elevationGain": elevationGain,
                  "maxElevation": maxElevation,
                  "steps": steps,
                  "path": pathPoints.map((p) =>
                  {
                    "lat": p.latitude,
                    "lng": p.longitude
                  }).toList(),
                  "mapImage": image,
                },
              ),
        ),
      );
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
            avgPace = 0.0; // Default when standing still
          }
        });
      }
    });
  }


  static Widget expandTimeWidget(){
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Time', style: CustomTextStyles.semiBold()),
          Text('00:00:00', style: CustomTextStyles.bold(fontSize: 80),),
          Divider(),
          Text('AVG PACE', style: CustomTextStyles.semiBold()),
          Text('0:00', style: CustomTextStyles.bold(fontSize: 150),),
          Text('/KM', style: CustomTextStyles.semiBold()),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 50,
                    color: Colors.blue,
                  ),
                  Text('0:00', style: CustomTextStyles.semiBold()),
                ],
              ),

              SizedBox(
                height: 200,
                child: VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                  // width: 20,
                ),
              ),
              Column(
                children: [
                  Text('DISTANCE', style: CustomTextStyles.semiBold()),
                  Text('0:00', style: CustomTextStyles.bold(fontSize: 70),),
                  Text('KILOMETERS', style: CustomTextStyles.semiBold()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
