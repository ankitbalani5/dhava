import 'dart:async';
import 'dart:math';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/resultScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/localDBModel/WorkoutModel.dart';


class FeedDetails extends StatefulWidget {
  const FeedDetails({super.key});

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
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

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Location permission is required to track.")),
        );
      }
      Navigator.pop(context);
      return;
    }

    try {
      Position pos = await Geolocator.getCurrentPosition();
      LatLng initial = LatLng(pos.latitude, pos.longitude);

      setState(() {
        pathPoints.add(initial);
        startTime = DateTime.now();
      });

      startLocationStream();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get location: $e")),
        );
      }
    }
  }

  void startLocationStream() {
    positionStream = Geolocator.getPositionStream(
      locationSettings:  LocationSettings(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text("Strava Tracker")
      // ),
      body: pathPoints.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: CustomScrollView(
                    slivers: [
            // Sliver AppBar with Map
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
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
                      /*Image.asset(
                        'assets/map_sample.png', // Use your map image or widget here
                        fit: BoxFit.cover,
                      ),*/
                    ),
            
                    // const Positioned(
                    //   bottom: 20,
                    //   right: 20,
                    //   child: CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     child: Icon(Icons.play_arrow, color: Colors.black),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            
            // Sliver content (Run details)
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header
                    // ListTile(
                    //   leading: const CircleAvatar(
                    //     backgroundImage: AssetImage(AppImageOthers.user),
                    //   ),
                    //   title: const Text(
                    //     'Jessica Taylor',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   subtitle: const Text(
                    //     'August 15, 2025 at 8:20 AM · Iskandar Puteri, Malaysia',
                    //     style: TextStyle(color: Colors.white70, fontSize: 12),
                    //   ),
                    //   trailing: Icon(Icons.more_vert, color: Colors.white),
                    // ),
                    // const SizedBox(height: 10),
            
                    // Run Summary
                    // Image.asset(AppImageOthers.feedCard1),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   // image: AssetImage('assets/shoe_bg.png'),
                        //   image: AssetImage(AppImageOthers.feedCard1),
                        //   fit: BoxFit.cover,
                        //   // colorFilter: ColorFilter.mode(
                        //   //     Colors.black.withOpacity(0.4), BlendMode.darken),
                        // ),
                        borderRadius: BorderRadius.circular(12),
                        // color: Colors.brown.shade900,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage(AppImageOthers.user),
                            ),
                            title: const Text(
                              'Jessica Taylor',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: const Text(
                              'August 15, 2025 at 8:20 AM · Iskandar Puteri, Malaysia',
                              style: TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            // trailing: Icon(Icons.more_vert, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const Text("Lunch Run",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _InfoColumn(title: "Distance", value: "10.35 km"),
                              SizedBox(width: 15,),
                              _InfoColumn(title: "Pace", value: "5:51 /km"),
                              SizedBox(width: 15,),
                              _InfoColumn(title: "Time", value: "1h 0m"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _InfoColumn(title: "Elevation Gain", value: "0 m"),
                              SizedBox(width: 15,),
                              _InfoColumn(
                                  title: "Max Elevation", value: "419 m"),
                              SizedBox(width: 15,),
                              _InfoColumn(title: "Steps", value: "10797"),
                              // SizedBox(width: 15,),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
            
                              Row(
                                children: [
                                  likeImageWidget(),
                                  SizedBox(width: 10,),
                                  Text('8 gave kudos', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
            
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.thumb_up,
                                      color: Colors.black),
                                  SizedBox(width: 8,),
                                  Icon(Icons.share,
                                      color: Colors.black),
                                ],
                              ),
                              // Text(
                              //   "With someone who didn’t record?",
                              //   style: TextStyle(color: Colors.black),
                              // ),
                              // Text(
                              //   "Add Others",
                              //   style: TextStyle(
                              //       color: Colors.orange,
                              //       fontWeight: FontWeight.bold),
                              // ),
                            ],
                          ),
                          // const SizedBox(height: 10),
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     Icon(Icons.thumb_up_alt_outlined,
                          //         color: Colors.black),
                          //     Icon(Icons.chat_bubble_outline, color: Colors.black),
                          //     Icon(Icons.share_outlined, color: Colors.black),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
            
                    // const SizedBox(height: 20),
                    //
                    // Container(
                    //   height: 156,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       // image: AssetImage('assets/shoe_bg.png'),
                    //       image: AssetImage(AppImageOthers.feedCard2),
                    //       fit: BoxFit.cover,
                    //       // colorFilter: ColorFilter.mode(
                    //       //     Colors.black.withOpacity(0.4), BlendMode.darken),
                    //     ),
                    //     borderRadius: BorderRadius.circular(12),
                    //     color: Colors.brown.shade900,
                    //   ),
                    //   padding: const EdgeInsets.all(16),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Matched Runs', style: CustomTextStyles.semiBold(fontSize: 20),),
                    //           Text('This Run', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                    //           Text('10:47 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                    //
                    //         ],
                    //       ),
                    //
                    //       // Right Graph Section
                    //       Column(
                    //         children: [
                    //           SizedBox(
                    //             width: 120,
                    //             height: 90,
                    //             child: CustomPaint(
                    //               painter: MatchedRunsGraphPainter(),
                    //             ),
                    //           ),
                    //           SizedBox(height: 15,),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.end,
                    //             children: [
                    //               Text('View 22 Matched Runs', style: CustomTextStyles.medium(fontSize: 12, textColor: AppColor.bgRed),)
                    //             ],
                    //           )
                    //         ],
                    //       )
                    //
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 20),
            
                    // results
                    Container(
                      height: 324,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   // image: AssetImage('assets/shoe_bg.png'),
                        //   image: AssetImage(AppImageOthers.feedCard3),
                        //   fit: BoxFit.cover,
                        //   // colorFilter: ColorFilter.mode(
                        //   //     Colors.black.withOpacity(0.4), BlendMode.darken),
                        // ),
                        // borderRadius: BorderRadius.circular(12),
                        // color: Colors.brown.shade900,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Best Efforts', style: CustomTextStyles.semiBold(fontSize: 20)),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Best Efforts', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                                  Text('4', style: CustomTextStyles.regular(fontSize: 16)),
                                ],
                              ),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Segments', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                  Text('5', style: CustomTextStyles.regular(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                  Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                  Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                  Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('View All Results', style: CustomTextStyles.medium(fontSize: 12, textColor: AppColor.bgRed),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
            
                    // splits
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   // image: AssetImage('assets/shoe_bg.png'),
                        //   image: AssetImage(AppImageOthers.feedCard4),
                        //   fit: BoxFit.cover,
                        //   // colorFilter: ColorFilter.mode(
                        //   //     Colors.black.withOpacity(0.4), BlendMode.darken),
                        // ),
                        // borderRadius: BorderRadius.circular(12),
                        // color: Colors.brown.shade900,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Splits', style: CustomTextStyles.semiBold(fontSize: 20)),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Km', style: CustomTextStyles.regular(fontSize: 10)),
                                    SizedBox(height: 10,),
                                    Text('1 Mile', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('1K', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('1/2 Mile', style: CustomTextStyles.regular(fontSize: 10)),
            
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pace', style: CustomTextStyles.regular(fontSize: 10)),
                                    SizedBox(height: 10,),
                                    Text('1 Mile', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('1K', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('1/2 Mile', style: CustomTextStyles.regular(fontSize: 10)),
            
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(''),
                                    SizedBox(height: 5,),
                                    Container(
                                      height: 13,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColor.bgRed,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 13,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: AppColor.bgRed,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 13,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: AppColor.bgRed,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Elev', style: CustomTextStyles.regular(fontSize: 10)),
                                    SizedBox(height: 10,),
                                    Text('-0', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('0', style: CustomTextStyles.regular(fontSize: 10)),
            
                                    SizedBox(height: 10,),
                                    Text('1', style: CustomTextStyles.regular(fontSize: 10)),
            
                                  ],
                                ),
                              ],
                            )
                          ]
                      ),
                    ),
                    const SizedBox(height: 20),
            
                    Container(
                      height: 580,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   // image: AssetImage('assets/shoe_bg.png'),
                        //   image: AssetImage(AppImageOthers.feedCard5),
                        //   fit: BoxFit.cover,
                        //   // colorFilter: ColorFilter.mode(
                        //   //     Colors.black.withOpacity(0.4), BlendMode.darken),
                        // ),
                        // borderRadius: BorderRadius.circular(12),
                        // color: Colors.brown.shade900,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pace', style: CustomTextStyles.semiBold(fontSize: 20)),
                              Icon(Icons.info_outline, color: Colors.black,)
                            ],
                          ),
                          SizedBox(height: 40,),
            
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: const Color(0xFF1E0E0E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              height: 220, // <-- FIXED HEIGHT ADDED
                              width: double.infinity, // <-- FIXED WIDTH ADDED
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: 2.0,
                                  minY: 415,
                                  maxY: 430,
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 32,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(color: Colors.black, fontSize: 12),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        getTitlesWidget: (value, meta) {
                                          if (value == 0.5 || value == 1.0 || value == 1.5 || value == 2.0) {
                                            return Text(
                                              '${value.toStringAsFixed(1)} Km',
                                              style: const TextStyle(color: Colors.black, fontSize: 12),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 420),
                                        FlSpot(0.5, 421),
                                        FlSpot(1.0, 420.5),
                                        FlSpot(1.5, 423),
                                        FlSpot(2.0, 421),
                                      ],
                                      isCurved: true,
                                      color: AppColor.bgRed,
                                      barWidth: 2,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.bgRed,
                                            // Colors.white.withOpacity(0.6),
                                            Colors.white,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      dotData: FlDotData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Avg Pace', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('10:47 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Moving Time', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('24:07', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Avg Elapsed Pace', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('46:32:36/Km', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Elapsed Time', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('104:07:37', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Fastest Split', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('10:20 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
            
                    // elevation
                    Container(
                      height: 410,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   // image: AssetImage('assets/shoe_bg.png'),
                        //   image: AssetImage(AppImageOthers.feedCard2),
                        //   fit: BoxFit.cover,
                        //   // colorFilter: ColorFilter.mode(
                        //   //     Colors.black.withOpacity(0.4), BlendMode.darken),
                        // ),
                        // borderRadius: BorderRadius.circular(12),
                        // color: Colors.brown.shade900,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Elevation', style: CustomTextStyles.semiBold(fontSize: 20)),
                              Icon(Icons.info_outline, color: Colors.black,),
                            ],
                          ),
                          SizedBox(height: 15,),
            
                          Container(
                            padding: const EdgeInsets.all(12),
                            // decoration: BoxDecoration(
                            //   color: const Color(0xFF1E0E0E),
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                            child: SizedBox(
                              height: 220, // <-- FIXED HEIGHT ADDED
                              width: double.infinity, // <-- FIXED WIDTH ADDED
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: 2.0,
                                  minY: 415,
                                  maxY: 430,
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 32,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(color: Colors.black, fontSize: 12),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        getTitlesWidget: (value, meta) {
                                          if (value == 0.5 || value == 1.0 || value == 1.5 || value == 2.0) {
                                            return Text(
                                              '${value.toStringAsFixed(1)} Km',
                                              style: const TextStyle(color: Colors.black, fontSize: 12),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 420),
                                        FlSpot(0.5, 421),
                                        FlSpot(1.0, 420.5),
                                        FlSpot(1.5, 423),
                                        FlSpot(2.0, 421),
                                      ],
                                      isCurved: true,
                                      color: Colors.white,
                                      barWidth: 2,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.bgRed,
                                            Colors.white,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      dotData: FlDotData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Elevation Gain', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('0m', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Max Elevation', style: CustomTextStyles.regular(fontSize: 12)),
                              Text('422m', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Problem with your location data?', style: CustomTextStyles.regular(fontSize: 14)),
            
                        Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              // color: AppColor.bgRed
                              border: Border.all(color: AppColor.bgRed)
                          ),
                          child: Center(
                            child: Text('Report', style: TextStyle(color: AppColor.bgRed),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
                    ],
                  ),
          )

      /*Stack(
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
              Positioned(
                top: 40,
                  left: 15,
                  child: BackButtonWidget(backgroundColor: Colors.black, arrowColor: Colors.white,)
              )
            ],
          ),*/
      // floatingActionButton: FloatingActionButton(
      //   onPressed: stopTracking,
      //   child: const Icon(Icons.stop),
      // ),
    );
  }


  static Widget likeImageWidget (){
    return Stack(
      children: [
        Container(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppImageOthers.userImg, height: 30,),
            ],
          ),
        ),

        Positioned(
            right: 25,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
        Positioned(
            right: 50,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
      ],
    );
  }

}



class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }



}

class MatchedRunsGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    final double verticalSpacing = size.width / 4;

    // Draw vertical grid lines
    for (int i = 0; i <= 3; i++) {
      final double x = verticalSpacing * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw blue line
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.7);
    canvas.drawPath(path, linePaint);

    // Draw white dots
    final Paint whiteDot = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.6), 4, whiteDot);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.3), 4, whiteDot);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.7), 4, whiteDot);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.5), 4, whiteDot);

    // Draw red highlighted dot (last point)
    final Paint redDot = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(size.width, size.height * 0.7), 5, redDot);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;


}