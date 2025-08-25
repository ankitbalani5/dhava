
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/saveActivity.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import '../../../data/localDBModel/WorkoutModel.dart';
import '../../defaultScreen/defaultScreen.dart';


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

  @override
  void initState() {
    super.initState();
    initTracking();
  }

  Future<void> initTracking() async {
    await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition();
    LatLng initial = LatLng(pos.latitude, pos.longitude);

    setState(() {
      pathPoints.add(initial);
      startTime = DateTime.now();
    });

    startLocationStream();
  }

  void startLocationStream() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      if (pathPoints.isNotEmpty) {
        totalDistance += _calculateDistance(pathPoints.last, newPos);
      }

      setState(() {
        pathPoints.add(newPos);
      });

      mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
    });
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

    DateTime endTime = DateTime.now();
    double durationSeconds = endTime.difference(startTime!).inSeconds.toDouble();
    double averageSpeed = totalDistance / durationSeconds; // m/s

    final workout = WorkoutModel(
      path: pathPoints,
      totalDistance: totalDistance,
      averageSpeed: averageSpeed,
      startTime: startTime!,
      endTime: endTime,
    );

    final box = Hive.box<WorkoutModel>('workouts');
    await box.add(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout saved!")),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tracking', style: CustomTextStyles.bold(),),
        leading: Icon(Icons.arrow_back_ios, color: Colors.white,),
        backgroundColor: Colors.black,
      ),
      body: pathPoints.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isShort ? Stack(
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
                      height: 200,
                      color: AppColor.textBackgroundGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Time', style: CustomTextStyles.bold(),),
                                  Text('00:01:01', style: CustomTextStyles.bold(fontSize: 36)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Km', style: CustomTextStyles.bold()),
                                  Text('0.01', style: CustomTextStyles.bold(fontSize: 36)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('AVG PACE', style: CustomTextStyles.bold()),
                                  Text('0:01', style: CustomTextStyles.bold(fontSize: 36)),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 50,
                                    color: Colors.blue,
                                  ),
                                  Text('1', style: CustomTextStyles.bold()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ) : GestureDetector(
          onTap: () {
            isShort = !isShort;
            setState(() {

            });
          },
          child: TimeWidget()
      ),
      /*Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text("Tracking", style: CustomTextStyles.bold()),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    AppImageOthers.map,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
            ],
          ),
        ),
      ),*/
      bottomNavigationBar: SizedBox(
        height: isShort ? 125 : 70,
        child: isShort ? Column(
          children: [
            Container(
              height: 60,
              color: AppColor.textBackgroundGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DefaultScreen()))
                      },
                      child: SvgPicture.asset(AppImageSvg.run),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DefaultScreen()))
                      },
                      child: SvgPicture.asset(AppImageSvg.walk),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DefaultScreen()))
                      },
                      child: SvgPicture.asset(AppImageSvg.cycle),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            GestureDetector(
              onTap: () {
                showCongratulationDialog(context);
              },
              child: Container(
                height: 60,
                child: Center(child: SvgPicture.asset(AppImageSvg.play)),
              ),
            ),
          ],
        )
            : Container(
          height: 60,
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              SvgPicture.asset(AppImageSvg.pause),
              SvgPicture.asset(AppImageSvg.map),
              SizedBox()
            ],
          )),
        ),
      ),
    );
  }

  Widget TimeWidget(){
    return Container(
      width: double.infinity,
      color: Colors.black,
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
                  color: Colors.white,
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

  void showCongratulationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🏆 Trophy Image
              Image.asset(
                AppImageOthers.trophy, // <-- Replace with your actual image path
                height: 180,
              ),

              const SizedBox(height: 20),

              // 🎉 Bold Title
              Text(
                'Congratulation!',
                style: CustomTextStyles.bold(fontSize: 26, textColor: Colors.black)
              ),

              const SizedBox(height: 10),

              // ✨ Subtitle
              Text(
                'You did a great job in the test!',
                style: CustomTextStyles.regular(textColor: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // 🔘 Continue Button
              CustomButton(
                text: 'Continue',
                callback: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
                  },
              )
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.orangeAccent, // Button color
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pop(); // Close the dialog
              //     },
              //     child: const Text(
              //       'Continue',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

}
