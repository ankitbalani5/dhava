
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
  double totalDistance = 0.0; // in meters
  DateTime? startTime;
  var startActivity = false;
  var start = false;
  var pause = false;
  Timer? _timer;
  Duration elapsed = Duration.zero;
  double avgPace = 0.0; // sec per km
  double elevationGain = 0.0;
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

  // split-related (real-time)
  double lastSplitDistance = 0.0; // absolute distance at last split (meters)
  DateTime? lastSplitTime;
  List<Map<String, dynamic>> liveSplits = []; // store generated splits
  String? pace_str;
  String? split_str;
  String? elevation_str;
  String? split_string;

  static const double splitIntervalMeters = 20.0;

  @override
  void initState() {
    super.initState();
    runType = widget.categoryId;
    categoryName = widget.categoryName;
    categoryIcon = widget.categoryIcon;
    initTracking();
    initStepTracking();
  }

  Future<void> initTracking() async {
    try {
      await Geolocator.requestPermission();
    } catch (e) {
      print("Permission error: $e");
    }
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng initial = LatLng(pos.latitude, pos.longitude);
      setState(() {
        pathPoints.add(initial);
        pointTimestamps.add(DateTime.now());
        altitudeList.add(pos.altitude);
        startTime = DateTime.now();
      });
    } catch (e) {
      print("Init position error: $e");
    }
  }

  void initStepTracking() {
    try {
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
    } catch (e) {
      print("Pedometer init error: $e");
    }
  }

  void startLocationStream() {
    positionStream?.cancel();
    // reset split baseline when starting/resuming
    if (lastSplitTime == null) lastSplitTime = startTime ?? DateTime.now();
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((position) {
      if (!pause && startActivity) {
        _handlePosition(position);
      }
    }, onError: (e) {
      print("Position stream error: $e");
    });
  }
  double nextSplitDistance = 20.0; // <-- define at class level
// Example: double nextSplitDistance = splitIntervalMeters;

  void _handlePosition(Position position) {
    LatLng newPos = LatLng(position.latitude, position.longitude);
    DateTime now = DateTime.now();

    if (pathPoints.isEmpty) {
      pathPoints.add(newPos);
      pointTimestamps.add(now);
      altitudeList.add(position.altitude);
      return;
    }

    double segmentDistance = _calculateDistance(pathPoints.last, newPos);
    if (segmentDistance < 0.5) return; // ignore GPS noise

    totalDistance += segmentDistance;
    pathPoints.add(newPos);
    pointTimestamps.add(now);
    altitudeList.add(position.altitude);

    // Elevation tracking
    if (lastElevation != 0.0) {
      double diff = position.altitude - lastElevation;
      if (diff > 1.0) elevationGain += diff;
    }
    lastElevation = position.altitude;
    if (position.altitude.round() > maxElevation) {
      maxElevation = position.altitude.round();
    }

    // ✅ Real-time split logic (fixed)
    while (totalDistance >= nextSplitDistance) {
      Duration splitDuration;
      if (lastSplitTime == null) {
        splitDuration = now.difference(startTime ?? now);
      } else {
        splitDuration = now.difference(lastSplitTime!);
      }

      double paceSecPerKm =
          splitDuration.inSeconds / (splitIntervalMeters / 1000);
      if (paceSecPerKm.isNaN || paceSecPerKm.isInfinite) paceSecPerKm = 0.0;

      String paceStr = formatPace(paceSecPerKm);
      String distanceStr = (nextSplitDistance / 1000.0).toStringAsFixed(2);
      String timeStr =
          "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}";

      double splitElevationGain =
      _computeElevationBetween(lastSplitDistance, nextSplitDistance);

      Map<String, dynamic> splitItem = {
        "split": liveSplits.length + 1,
        "distance": distanceStr,
        "pace": paceStr,
        "time": timeStr,
        "elevation": splitElevationGain.toStringAsFixed(1),
        "timestamp": now.toIso8601String(),
      };

      liveSplits.add(splitItem);
      lastSplitDistance = nextSplitDistance;
      lastSplitTime = now;
      nextSplitDistance += splitIntervalMeters; // 🔥 Move next target forward

      print(
          "✅ Real-time Split #${splitItem['split']} | ${splitItem['distance']} km | Pace ${splitItem['pace']}");
    }

    // Keep map following the runner
    mapController?.animateCamera(CameraUpdate.newLatLng(newPos));

    _updateSplitStrings();
    setState(() {});
  }

  double _computeElevationBetween(double absStart, double absEnd) {
    if (altitudeList.length < 2 || pathPoints.length < 2) return 0.0;

    double cum = 0.0;
    double elevationGainLocal = 0.0;

    for (int i = 1; i < pathPoints.length; i++) {
      double seg = _calculateDistance(pathPoints[i - 1], pathPoints[i]);
      double segStart = cum;
      double segEnd = cum + seg;

      if (segEnd <= absStart) {
        cum = segEnd;
        continue;
      }
      if (segStart >= absEnd) break;

      double from = max(segStart, absStart);
      double to = min(segEnd, absEnd);
      double portionStartRatio = seg > 0 ? ((from - segStart) / seg) : 0.0;
      double portionEndRatio = seg > 0 ? ((to - segStart) / seg) : 1.0;

      double altPrev = (altitudeList.length > i - 1) ? altitudeList[i - 1] : lastElevation;
      double altCurr = (altitudeList.length > i) ? altitudeList[i] : lastElevation;
      double altStart = altPrev + (altCurr - altPrev) * portionStartRatio;
      double altEnd = altPrev + (altCurr - altPrev) * portionEndRatio;
      double diff = altEnd - altStart;
      // if (diff > 1.0) elevationGainLocal += diff;
      if (diff > 0.2) elevationGainLocal += diff; // 20 cm से ऊपर count करो

      cum = segEnd;
    }

    return elevationGainLocal;
  }

  void _updateSplitStrings() {
    List<String> paceArr = [];
    List<String> splitArr = [];
    List<String> elevationArr = [];

    for (var s in liveSplits) {
      paceArr.add(s['pace']);
      splitArr.add(s['distance']);
      elevationArr.add(s['elevation'].toString());
    }

    pace_str = paceArr.join(',');
    split_str = splitArr.join(',');
    elevation_str = elevationArr.join(',');
    split_string = liveSplits.map((s) {
      return """{
  "split": ${s['split']},
  "distance": "${s['distance']}",
  "pace": "${s['pace']}",
  "time": "${s['time']}",
  "elevation": "${s['elevation']}"
}""";
    }).join(",\n");
  }

  Map<String, dynamic> calculateResults() {
    List<Map<String, dynamic>> splitsLocal = liveSplits.isNotEmpty ? liveSplits : calculateSplitsOnFinish();
    double fastestSplit = double.infinity;
    if (splitsLocal.isNotEmpty) {
      for (var split in splitsLocal) {
        final pace = split['pace'] ?? "0:00";
        final parts = pace.split(':');
        int minutes = 0;
        int seconds = 0;
        if (parts.length >= 2) {
          minutes = int.tryParse(parts[0]) ?? 0;
          seconds = int.tryParse(parts[1].replaceAll('/km', '')) ?? 0;
        }
        final secondsTotal = (minutes * 60) + seconds;
        if (secondsTotal < fastestSplit) fastestSplit = secondsTotal.toDouble();
      }
    } else {
      fastestSplit = 0.0;
    }

    double avgPaceLocal = elapsed.inSeconds > 0 && totalDistance > 0
        ? elapsed.inSeconds / (totalDistance / 1000) // seconds per km
        : 0.0;

    return {
      "totalDistance": totalDistance, // meters
      "elapsedTime": elapsed.inSeconds,
      "fastestSplit": fastestSplit,
      "segments": splitsLocal.length,
      "splits": splitsLocal,
      'avgPace': avgPaceLocal
    };
  }

  /// Fallback: compute splits on finish if liveSplits empty (keeps consistency)
  List<Map<String, dynamic>> calculateSplitsOnFinish() {
    List<Map<String, dynamic>> splitsLocal = [];
    if (pathPoints.length < 2 || pointTimestamps.length < 2) return splitsLocal;

    double accumulatedDistance = 0.0;
    DateTime splitStartTime = pointTimestamps.first;
    double producedLastSplitAbs = 0.0;
    int splitCount = 0;

    for (int i = 1; i < pathPoints.length; i++) {
      double seg = _calculateDistance(pathPoints[i - 1], pathPoints[i]);
      accumulatedDistance += seg;

      while (accumulatedDistance >= splitIntervalMeters) {
        producedLastSplitAbs += splitIntervalMeters;

        DateTime now = pointTimestamps.length > i ? pointTimestamps[i] : DateTime.now();
        Duration splitDuration = now.difference(splitStartTime);
        if (splitDuration.isNegative) splitDuration = Duration.zero;
        double paceSecPerKm = splitDuration.inSeconds / (splitIntervalMeters / 1000.0);
        String paceStr = formatPace(paceSecPerKm);
        splitCount++;
        String distanceStr = (producedLastSplitAbs / 1000.0).toStringAsFixed(2);
        String timeStr = "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}";

        // elevation approx
        double splitElevation = _computeElevationBetween(producedLastSplitAbs - splitIntervalMeters, producedLastSplitAbs);

        splitsLocal.add({
          "split": splitCount,
          "distance": distanceStr,
          "pace": paceStr,
          "time": timeStr,
          "elevation": splitElevation.toStringAsFixed(1),
          "timestamp": now.toIso8601String(),
        });

        splitStartTime = DateTime.parse(splitsLocal.last['timestamp']);
        accumulatedDistance -= splitIntervalMeters;
      }
    }

    // final partial remainder
    double remainder = totalDistance - producedLastSplitAbs;
    if (remainder > 0.0) {
      DateTime lastSplitStart = splitsLocal.isEmpty ? pointTimestamps.first : DateTime.parse(splitsLocal.last['timestamp']);
      DateTime lastPointTime = pointTimestamps.last;
      Duration splitDuration = lastPointTime.difference(lastSplitStart);
      if (splitDuration.isNegative) splitDuration = Duration.zero;
      double paceSecPerKm = (remainder > 0) ? (splitDuration.inSeconds / (remainder / 1000.0)) : 0.0;
      String paceStr = formatPace(paceSecPerKm);
      String distanceStr = (totalDistance / 1000.0).toStringAsFixed(2);
      String timeStr = "${splitDuration.inMinutes}:${(splitDuration.inSeconds % 60).toString().padLeft(2, '0')}";

      double splitElevation = _computeElevationBetween(producedLastSplitAbs, totalDistance);

      splitsLocal.add({
        "split": splitsLocal.length + 1,
        "distance": distanceStr,
        "pace": paceStr,
        "time": timeStr,
        "elevation": splitElevation.toStringAsFixed(1),
        "timestamp": lastPointTime.toIso8601String(),
      });
    }

    setState(() {
      liveSplits = splitsLocal;
    });
    _updateSplitStrings();
    return splitsLocal;
  }

  String formatPace(double paceInSec) {
    if (paceInSec.isInfinite || paceInSec.isNaN || paceInSec <= 0) return "0:00";
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    if (min < 0) min = 0;
    if (sec < 0) sec = 0;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371000; // Earth radius in meters
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLng = _degToRad(end.longitude - start.longitude);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degToRad(start.latitude)) *
            cos(_degToRad(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (3.1415926535 / 180.0);

  void stopTracking() async {
    positionStream?.cancel();
    _timer?.cancel();
    startActivity = false;
    start = false;
    pause = false;

    DateTime endTime = DateTime.now();
    double durationSeconds = endTime.difference(startTime ?? endTime).inSeconds.toDouble();
    double averageSpeed = durationSeconds > 0 ? (totalDistance / durationSeconds) : 0.0; // m/s
    print("Stopped. Duration: $durationSeconds s, Avg speed: $averageSpeed m/s");
  }

  Set<Polyline> getPolyline() {
    return {
      Polyline(
        polylineId: const PolylineId("track"),
        color: AppColor.bgRed,
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('current State from tracking:::${bottomNavKey.currentState?.currentTap}');
        bottomNavKey.currentState?.changeTab(2);
        Navigator.of(context).pop();
        return false;
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
                  ? SizedBox()
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
                  child: expandTimeWidget(elapsed: elapsed, distance: totalDistance)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  isShort = !isShort;
                  setState(() {});
                },
                child: Container(
                  height: !isShort ? 150 : 220,
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [AppColor.bgRed.withOpacity(.5), Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          categoryName.toString(),
                          style: CustomTextStyles.medium(fontSize: 18),
                        ),
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
                                          style: CustomTextStyles.regular(
                                              fontSize: 20, textColor: Colors.black)),
                                    ],
                                  ),
                                  Text('Time', style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(formatPace(avgPace), style: CustomTextStyles.bold(fontSize: 26)),
                                  Text('Split avg. pace (/km)', style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text((totalDistance / 1000).toStringAsFixed(2),
                                      style: CustomTextStyles.bold(fontSize: 26)),
                                  Text('Distance (km)', style: CustomTextStyles.medium(fontSize: 11, textColor: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        bottomButton()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButton() {
    return SizedBox(
        height: isShort ? 70 : 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                !start ? startWidget() : !pause ? pauseWidget() : resume()
              ],
            ),
          ],
        ));
  }

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
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                    onTap: () {
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

  Widget startWidget() {
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
                      color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: AppColor.bgRed)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(categoryIcon ?? "", height: 25, color: AppColor.bgRed),
                  ))),
          GestureDetector(
            onTap: () async {
              start = true;
              startActivity = true;
              pause = false;

              startTime = DateTime.now();
              lastSplitTime = startTime;
              lastSplitDistance = 0.0;
              // reset run variables
              totalDistance = 0.0;
              elapsed = Duration.zero;
              avgPace = 0.0;
              elevationGain = 0.0;
              lastElevation = 0.0;
              maxElevation = 0;
              pathPoints = [];
              pointTimestamps = [];
              altitudeList = [];
              liveSplits = [];
              pace_str = null;
              split_str = null;
              elevation_str = null;
              split_string = null;

              await getCurrentAddress();

              // add initial point
              try {
                Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                LatLng initial = LatLng(pos.latitude, pos.longitude);
                setState(() {
                  pathPoints.add(initial);
                  pointTimestamps.add(DateTime.now());
                  altitudeList.add(pos.altitude);
                });
              } catch (e) {
                print("Error getting initial position: $e");
              }

              startLocationStream();
              startTimer();
              setState(() {});
            },
            child: SizedBox(
              height: 60,
              width: 60,
              child: Center(child: SvgPicture.asset(AppImageSvg.play, height: 60, width: 60)),
            ),
          ),
          GestureDetector(onTap: () {
            isShort = !isShort;
            setState(() {});
          }, child: Image.asset(AppImageOthers.expand, height: 50)),
          SizedBox(),
        ],
      ),
    );
  }

  Future<void> getCurrentAddress() async {
    try {
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

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("📍 Lat: ${position.latitude}, Lng: ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
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

  Widget pauseWidget() {
    return GestureDetector(
      onTap: () {
        pause = true;
        positionStream?.pause();
        _timer?.cancel();
        setState(() {});
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.bgRed),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImageOthers.pause, height: 18),
            SizedBox(width: 5),
            Text('Pause', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget resume() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                pause = false;
                positionStream?.resume();
                startActivity = true;
                startTimer();
                setState(() {});
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.bgRed),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImageOthers.resume, height: 24),
                    SizedBox(width: 5),
                    Text('Resume', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white))
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImageOthers.finish, height: 24),
                    SizedBox(width: 5),
                    Text('Finish', style: CustomTextStyles.semiBold(fontSize: 20, textColor: Colors.white))
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No tracking data found!")));
      return;
    }

    // live splits already generated in real-time; but fallback to calculate if empty
    if (liveSplits.isEmpty) {
      calculateSplitsOnFinish();
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

        final cropHeight = (fullHeight - topOffset - bottomSheetHeight).clamp(0, fullHeight).toInt();

        final cropped = img.copyCrop(screenShotImg, x: 0, y: topOffset, width: fullWidth, height: cropHeight);

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
          "elevationGain": elevationGain.round(),
          "maxElevation": maxElevation,
          "steps": steps,
          "pace_str": pace_str,
          "split_str": split_string,
          "elavation_str": elevation_str,
          "path": pathPoints.map((p) => {"latitude": p.latitude.toString(), "longitude": p.longitude.toString()}).toList(),
          "photo": base64Image,
          "city": city,
          "state": state,
          "country": country,
          "address": address,
        };
        Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity(trackingData: trackingData)));
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

  Widget expandTimeWidget({required Duration elapsed, required double distance}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Time', style: CustomTextStyles.semiBold()),
                Text(formatElapsed(elapsed), style: CustomTextStyles.bold(fontSize: 40)),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('AVG PACE', style: CustomTextStyles.semiBold()),
                Text(formatPace(avgPace), style: CustomTextStyles.bold(fontSize: 70)),
                Text('/KM', style: CustomTextStyles.semiBold()),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.terrain, color: Colors.blue, size: 40),
                      SizedBox(height: 8),
                      Text("${elevationGain.toStringAsFixed(0)} m", style: CustomTextStyles.semiBold()),
                      Text("Elevation", style: CustomTextStyles.regular(fontSize: 12)),
                    ],
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey, width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('DISTANCE', style: CustomTextStyles.semiBold()),
                      Text("${(distance / 1000).toStringAsFixed(2)}", style: CustomTextStyles.bold(fontSize: 50)),
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
