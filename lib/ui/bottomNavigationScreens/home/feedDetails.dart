import 'dart:async';
import 'dart:math';
import 'package:coherent_endurance/bloc/feedDetailsBloc/feed_detail_bloc.dart';
import 'package:coherent_endurance/models/feedDetailModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constant/constant.dart';
import '../../../data/localDBModel/WorkoutModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/feedModel.dart';

class FeedDetails extends StatefulWidget {
  String activityId;
  FeedDetails({required this.activityId, super.key});

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
    context.read<FeedDetailBloc>().add(FetchFeedDetailEvent(context, widget.activityId));
    print('activityId::::${widget.activityId}');
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
      body: pathPoints.isEmpty
          ? Center(
        child: LoadingAnimationWidget.inkDrop(
          color: AppColor.bgRed,
          size: 20,
        ),
      )
          : BlocConsumer<FeedDetailBloc, FeedDetailState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is FeedDetailLoading){
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: AppColor.bgRed,
                size: 20,
              ),
            );
          }
          if(state is FeedDetailSuccess){
            var feedData = state.feedDetailModel.data;
            return SafeArea(
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
                          ),
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: AppColor.bgRed)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: feedData!.profilePic.toString(),
                                          width: 36.0,
                                          height: 36.0,
                                          fit: BoxFit.fill,
                                          placeholder:
                                              (context, url) =>
                                              Padding(
                                                padding: EdgeInsets.all(40.0),
                                                child: CircularProgressIndicator(
                                                  color: AppColor.bgRed,
                                                  strokeWidth: 1,
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(AppImageOthers.profilePic, height: 36,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${feedData.firstName} ${feedData.lastName}',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: feedData!.categoryIcon.toString(),
                                                width: 17.0,
                                                height: 17.0,
                                                fit: BoxFit.fill,
                                                color: AppColor.bgRed,
                                                placeholder:
                                                    (context, url) =>
                                                    Padding(
                                                      padding: EdgeInsets.all(40.0),
                                                      child: CircularProgressIndicator(
                                                        color: AppColor.bgRed,
                                                        strokeWidth: 1,
                                                      ),
                                                    ),
                                                errorWidget: (context,
                                                    url, error) =>
                                                    Image.asset(AppImageOthers.profilePic, height: 17,),
                                              ),
                                              SizedBox(width: 4,),
                                              Flexible(
                                                child: Text(
                                                  '${formatDate(feedData.createdDate.toString())} · ${feedData.location}',
                                                  // 'August 15, 2025 at 8:20 AM · Iskandar Puteri, Malaysia',
                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
                                  children: [
                                    _InfoColumn(title: "Distance", value: "${(double.parse(feedData.distance.toString())/1000)} km"),
                                    SizedBox(width: 15,),
                                    _InfoColumn(title: "Pace", value: "${feedData.pace} /km"),
                                    SizedBox(width: 15,),
                                    _InfoColumn(title: "Time", value: Constant.formatDuration(int.parse(feedData.movingTime.toString()))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InfoColumn(title: "Elevation Gain", value: "${feedData.elavationGain.toString()} m"),
                                    SizedBox(width: 15,),
                                    _InfoColumn(
                                        title: "Max Elevation", value: "${feedData.maxElavation} m"),
                                    SizedBox(width: 15,),
                                    _InfoColumn(title: "Steps", value: "${feedData.steps}"),
                                    // SizedBox(width: 15,),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Row(
                                      children: [
                                        likeImageWidget(state.feedDetailModel),
                                        SizedBox(width: 10,),
                                        Text('${feedData.totalLike} gave kudos', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.thumb_up,
                                            color: feedData.isLiked! ? AppColor.bgRed : Colors.black),
                                        SizedBox(width: 8,),
                                        Icon(Icons.share,
                                            color: Colors.black),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // results
                          // Container(
                          //   height: 324,
                          //   // padding: const EdgeInsets.all(16),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('Best Efforts', style: CustomTextStyles.semiBold(fontSize: 20)),
                          //       SizedBox(height: 15,),
                          //       Row(
                          //         children: [
                          //           Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text('Best Efforts', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                          //               Text('4', style: CustomTextStyles.regular(fontSize: 16)),
                          //             ],
                          //           ),
                          //           SizedBox(width: 20,),
                          //           Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text('Segments', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          //               Text('5', style: CustomTextStyles.regular(fontSize: 16)),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 15,),
                          //       Row(
                          //         children: [
                          //           Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          //               Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 15,),
                          //       Row(
                          //         children: [
                          //           Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          //               Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 15,),
                          //       Row(
                          //         children: [
                          //           Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text('1 Mile', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          //               Text('17:11   10:41 /Km', style: CustomTextStyles.regular(fontSize: 16)),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 15,),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           Text('View All Results', style: CustomTextStyles.medium(fontSize: 12, textColor: AppColor.bgRed),)
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 20),

                          // splits
                          Container(
                            height: 180,
                            // padding: const EdgeInsets.all(16),
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
                            // padding: const EdgeInsets.all(16),
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
                            // padding: const EdgeInsets.all(16),
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
            );
          }
          if(state is FeedDetailError){
            return Center(
              child: Text(state.error),
            );
          }
          return SizedBox();
        },
      )
    );
  }

  String formatDate(String dateStr) {
    // Parse incoming string to DateTime
    DateTime dateTime = DateTime.parse(dateStr);

    // Format it to required style
    String formatted = DateFormat("MMMM d, y 'at' h:mm a").format(dateTime);

    return formatted;
  }



  static Widget likeImageWidget (FeedDetailModel feed){
    return BlocConsumer<FeedDetailBloc, FeedDetailState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is FeedDetailSuccess) {
          // final feed = state.feedModel.data!;
          final likedUsers = feed.data!.likedUsers ?? [];

          if (likedUsers.isEmpty) {
            return const SizedBox();
          }

          final visibleUsers = likedUsers.take(4).toList();

          return SizedBox(
            width: feed.data!.likedUsers?.length == 1 ? 32 : feed.data!.likedUsers?.length == 2 ? 58 : feed.data!.likedUsers?.length == 3 ? 84 : 110,
            height: 40,
            child: Stack(
              children: List.generate(
                visibleUsers.length,
                    (index) {
                  final user = visibleUsers[index];
                  return Positioned(
                    right: index * 25, // overlap offset
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(imageUrl:
                        user.profilePic ?? "",
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          errorWidget: (context,
                              url, error) =>
                              Image.asset(AppImageOthers.userImg, height: 30, width: 30,),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return SizedBox();

      },
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

// class MatchedRunsGraphPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint gridPaint = Paint()
//       ..color = Colors.white.withOpacity(0.3)
//       ..strokeWidth = 1;
//
//     final double verticalSpacing = size.width / 4;
//
//     // Draw vertical grid lines
//     for (int i = 0; i <= 3; i++) {
//       final double x = verticalSpacing * i;
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
//     }
//
//     // Draw blue line
//     final Paint linePaint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     final Path path = Path();
//     path.moveTo(0, size.height * 0.3);
//     path.lineTo(size.width, size.height * 0.7);
//     canvas.drawPath(path, linePaint);
//
//     // Draw white dots
//     final Paint whiteDot = Paint()..color = Colors.white;
//     canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.6), 4, whiteDot);
//     canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.3), 4, whiteDot);
//     canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.7), 4, whiteDot);
//     canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.5), 4, whiteDot);
//
//     // Draw red highlighted dot (last point)
//     final Paint redDot = Paint()..color = Colors.red;
//     canvas.drawCircle(Offset(size.width, size.height * 0.7), 5, redDot);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
//
//
// }