import 'dart:async';
import 'dart:convert';
import 'package:coherent_endurance/bloc/feedDetailsBloc/feed_detail_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/models/feedDetailModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/otherProfileScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constant/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import '../../../models/feedModel.dart';
import '../../shareActivity.dart';

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
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    context.read<FeedDetailBloc>().add(FetchFeedDetailEvent(context, widget.activityId));
    print('activityId::::${widget.activityId}');
    // initTracking();
    _loadMarkerIcons();
  }
  late BitmapDescriptor startIcon;
  late BitmapDescriptor endIcon;
  bool iconsLoaded = false;


  Future<void> _loadMarkerIcons() async {
    Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!;
      return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    }

    startIcon = await getBytesFromAsset(AppImageOthers.startRun, 40);
    endIcon = await getBytesFromAsset(AppImageOthers.finishRun, 40);

    iconsLoaded = true;
    if (mounted) setState(() {});
  }

  // Future<void> _loadMarkerIcons() async {
  //   startIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 0.5), AppImageOthers.startRun);
  //   endIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 0.5), AppImageOthers.finishRun);
  //
  //   // icon load complete
  //   iconsLoaded = true;
  //
  //   // Build UI after icons loaded
  //   if (mounted) setState(() {});
  // }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
  void _fitToRoute() async {
    if (mapController == null || pathPoints.isEmpty) return;

    LatLngBounds bounds = _getLatLngBounds(pathPoints);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 140);
    mapController!.animateCamera(cameraUpdate);
  }

  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double x0 = points.first.latitude;
    double x1 = points.first.latitude;
    double y0 = points.first.longitude;
    double y1 = points.first.longitude;

    for (LatLng latLng in points) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  Set<Marker> markers = {};


  List<Map<String, dynamic>> parseSplitData(String splitStr) {
    if (splitStr.isEmpty) return [];

    try {
      // String को JSON array में wrap करके decode करो
      String formatted = "[$splitStr]";
      List<dynamic> decoded = jsonDecode(formatted);

      // Convert to List<Map<String, dynamic>>
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print("Error parsing split data: $e");
      return [];
    }
  }
  double _paceToDouble(String pace) {
    try {
      final parts = pace.split(':');
      final minutes = double.parse(parts[0]);
      final seconds = double.parse(parts[1]);
      return minutes + (seconds / 60); // total pace in minutes
    } catch (e) {
      return 0.0;
    }
  }

  double paceToMinutes(String pace) {
    try {
      final parts = pace.split(':');
      final minutes = double.parse(parts[0]);
      final seconds = double.parse(parts[1]);
      return minutes + (seconds / 60); // total minutes per km
    } catch (e) {
      return 0.0;
    }
  }
  double getNiceMaxX(double totalDistance) {
    if (totalDistance <= 0) return 1;
    // हमेशा अगले 0.5km step तक round up करो
    return (totalDistance * 2).ceil() / 2;
  }

  double getDynamicInterval(double totalDistance) {
    if (totalDistance <= 1) return 0.2;
    if (totalDistance <= 2) return 0.5;
    if (totalDistance <= 5) return 1;
    if (totalDistance <= 10) return 2;
    return 5;
  }

  // double getNiceMaxX(double totalDistance) {
  //   if (totalDistance <= 0) return 1;
  //   // Round up to next 0.5km or 1km for clean chart end
  //   double nice = (totalDistance * 2).ceilToDouble() / 2.0;
  //   return nice;
  // }
  //
  // double getDynamicInterval(double totalDistance) {
  //   // Decide interval dynamically based on total distance
  //   if (totalDistance <= 1) return 0.2;
  //   if (totalDistance <= 3) return 0.5;
  //   if (totalDistance <= 10) return 1.0;
  //   if (totalDistance <= 20) return 2.0;
  //   return 5.0;
  // }

  double paceToSeconds(String pace) {
    // Example pace: "05:32"
    final parts = pace.split(':');
    if (parts.length != 2) return 0;
    final minutes = double.tryParse(parts[0]) ?? 0;
    final seconds = double.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }

  Widget buildPaceChart(String splitStr) {
    try {
      // 🧩 1. Convert to List
      String formatted = "[${splitStr.trim()}]";
      List<dynamic> decoded = jsonDecode(formatted);
      List<Map<String, dynamic>> splits = decoded.cast<Map<String, dynamic>>();

      // 🧮 2. Convert to FlSpot List (use fixed 20m step cumulative)
      double cumulativeDistance = 0.0;
      const double stepKm = 0.02; // every 20 meter

      final List<FlSpot> spots = [];

      for (var s in splits) {
        double pace = paceToMinutes(s['pace'].toString());
        cumulativeDistance += stepKm; // increase fixed 0.02 km each time
        spots.add(FlSpot(cumulativeDistance, pace));
      }

      // 🧩 3. Handle empty
      if (spots.isEmpty) {
        return const Center(child: Text("No pace data"));
      }

      double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
      double maxX = spots.last.x;
      double intervalX = getDynamicInterval(maxX);

      // ✅ 4. Chart UI
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX,
              minY: minY - 1,
              maxY: maxY + 1,
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
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: intervalX,
                    getTitlesWidget: (value, meta) {
                      if (value > maxX) return const SizedBox.shrink();
                      return Text(
                        '${value.toStringAsFixed(2)} km',
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.6),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text("⚠️ Error parsing split data: $e"));
    }
  }

  Widget buildElevationChart(String splitStr) {
    try {
      String formatted = "[${splitStr.trim()}]";
      List<dynamic> decoded = jsonDecode(formatted);
      List<Map<String, dynamic>> splits = decoded.cast<Map<String, dynamic>>();

      double cumulativeDistance = 0.0;
      const double stepKm = 0.02; // every 20 meter
      final List<FlSpot> spots = [];

      for (var s in splits) {
        double elevation = double.tryParse(s['elevation'].toString()) ?? 0.0;
        cumulativeDistance += stepKm;
        spots.add(FlSpot(cumulativeDistance, elevation));
      }

      if (spots.isEmpty) {
        return const Center(child: Text("No elevation data"));
      }

      double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
      double maxX = spots.last.x;
      double intervalX = getDynamicInterval(maxX);

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX,
              minY: minY - 1,
              maxY: maxY + 1,
              gridData: FlGridData(show: true, drawVerticalLine: true, drawHorizontalLine: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: intervalX,
                    getTitlesWidget: (value, meta) {
                      if (value > maxX) return const SizedBox.shrink();
                      return Text(
                        '${value.toStringAsFixed(2)} km',
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [Colors.red.withOpacity(0.6), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text("⚠️ Error parsing elevation data: $e"));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<FeedDetailBloc, FeedDetailState>(
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
            pathPoints.clear();

            List<Map<String, dynamic>> splits = parseSplitData(feedData?.splitStr ?? "");

            print('pacestr:::::${feedData!.paceStr}');
            print('elevationstr:::::${feedData!.elavationStr}');
            print('splitstr:::::${feedData!.splitStr}');
            final double maxBarWidth = 150; // max width for slowest pace

            // ✅ Find max pace in seconds
            double maxPaceInSec = 0;
            for (var split in splits) {
              double paceInSec = paceToSeconds(split['pace'].toString());
              if (paceInSec > maxPaceInSec) {
                maxPaceInSec = paceInSec;
              }
            }

            // ✅ maxX को actual distance के हिसाब से लो
            final splitList = (feedData.splitStr ?? "").split(',');
            double totalDistance = 0.0;
            for (var s in splitList) {
              totalDistance += double.tryParse(s) ?? 0.0;
            }

            if (iconsLoaded || feedData?.path != null && feedData!.path!.isNotEmpty) {
              for (var p in feedData!.path!) {
                final lat = double.tryParse(p.latitude.toString());
                final lng = double.tryParse(p.longitude.toString());
                if (lat != null && lng != null) {
                  pathPoints.add(LatLng(lat, lng));
                }
              }

              polylines = {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: pathPoints,
                  color: AppColor.bgRed,
                  width: 5,
                ),
              };

              // if (!iconsLoaded || pathPoints.isEmpty) return;

                  if(iconsLoaded && pathPoints.length >= 2){
                    print('pathPoint:::${pathPoints.length}');
                markers.add(Marker(
                  markerId: MarkerId('start'),
                  position: pathPoints.first,
                  icon: startIcon,
                  infoWindow: InfoWindow(title: 'Start'),
                ));

                markers.add(Marker(
                  markerId: MarkerId('end'),
                  position: pathPoints.last,
                  icon: endIcon,
                  infoWindow: InfoWindow(title: 'End'),
                ));
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fitToRoute();
              });
            }

            return Stack(
              children: [
                /// 🔹 Map Widget (background)
                Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: pathPoints.isNotEmpty
                            ? pathPoints.first
                            : const LatLng(26.9124, 75.7873), // default Jaipur point
                        // zoom: 50,
                      ),
                      onMapCreated: (controller) {
                        mapController = controller;
                        if (pathPoints.isNotEmpty) {
                          _fitToRoute();
                        }
                      },
                      polylines: polylines,
                      markers: markers,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                    )
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: BackButtonWidget()
                  ),
                ),

                /// 🔹 Draggable Bottom Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.40, // Start height (35%)
                  minChildSize: 0.20,     // Min height = ~50px
                  maxChildSize: 1.0,      // Full screen max
                  snapSizes: [0.20, 0.40, 1.0], // multiple snap points
                  snap: true,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -3)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  // height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                          height: 5,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              feedData.userId == context.read<ProfileBloc>().profileModel!.data!.userId.toString()
                                                  ? ProfileScreen()
                                                  : OtherProfileScreen(userId: feedData.userId.toString()),
                                            ),
                                          );
                                        },
                                        child: Row(
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
                                      ),
                                      const SizedBox(height: 10),
                                      Text(feedData.title.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: _InfoColumn(cross: CrossAxisAlignment.start, title: "Distance", value: "${(double.parse(feedData.distance.toString())/1000).toStringAsFixed(2)} km")),
                                          SizedBox(width: 15,),
                                          Expanded(child: _InfoColumn(cross: CrossAxisAlignment.center, title: "Pace", value: "${Constant.formatPace(double.parse(feedData.pace.toString()))} /km")),
                                          SizedBox(width: 15,),
                                          Expanded(child: _InfoColumn(cross: CrossAxisAlignment.end, title: "Time", value: Constant.formatDuration(int.parse(feedData.movingTime.toString())))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: _InfoColumn(cross: CrossAxisAlignment.start, title: "Elevation Gain", value: "${feedData.elavationGain.toString()} m")),
                                          SizedBox(width: 15,),
                                          Expanded(
                                            child: _InfoColumn(cross: CrossAxisAlignment.center,
                                                title: "Max Elevation", value: "${feedData.maxElavation} m"),
                                          ),
                                          SizedBox(width: 15,),
                                          Expanded(child: _InfoColumn(cross: CrossAxisAlignment.end, title: "Steps", value: "${feedData.steps}")),
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
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<FeedDetailBloc>().add(ActivityLikeEvent(context: context, activityId: feedData.activityId.toString()));
                                                },
                                                child: Icon(Icons.thumb_up,
                                                    color: feedData.isLiked! ? AppColor.bgRed : Colors.black),
                                              ),
                                              SizedBox(width: 8,),
                                              GestureDetector(
                                                onTap: () {

                                                  final activityId = widget.activityId;
                                                  final link = "https://tracking.coherentlab.com/api/v1/activity/user-feed/$activityId";


                                                  showShareActivitySheet(context: context, distance: '${(double.parse(feedData.distance.toString()) / 1000).toStringAsFixed(2)} km',
                                                      elevation: feedData.elavationGain.toString(), imageProvider: NetworkImage(feedData.photo.toString()), time: feedData.movingTime.toString(),
                                                      title: feedData.title.toString(), link: link
                                                  );
                                                },
                                                child: Icon(Icons.share,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                Divider(color: Colors.grey.shade300,),
                                const SizedBox(height: 20),
                                Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Splits', style: CustomTextStyles.semiBold(fontSize: 20)),
                                        SizedBox(height: 15,),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Km', style: CustomTextStyles.regular(fontSize: 14)),
                                                SizedBox(width: 20,),
                                                Text('Pace', style: CustomTextStyles.regular(fontSize: 14)),
                                              ],
                                            ),
                                            SizedBox(width: 20,),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(''),
                                                  Text('Elev', style: CustomTextStyles.regular(fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                ...splits.map<Widget>((split) {
                                                  String splitDistance = split['distance'].toString();
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(splitDistance, style: CustomTextStyles.regular(fontSize: 14)),
                                                      const SizedBox(height: 10),
                                                    ],
                                                  );
                                                }).toList(),
                                              ],
                                            ),

                                            SizedBox(width: 10,),
                                            Column(
                                              children: [
                                                for (var pace in splits) ...[
                                                  Text(pace['pace'].toString(), style: CustomTextStyles.regular(fontSize: 14)),
                                                  const SizedBox(height: 10),
                                                ],
                                              ],
                                            ),
                                            SizedBox(width: 20,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  for (var split in splits) ...[
                                                    Builder(
                                                      builder: (context) {
                                                        double paceInSec = paceToSeconds(split['pace'].toString());
                                                        double ratio = paceInSec / maxPaceInSec; // 0 → 1
                                                        double barWidth = maxBarWidth * ratio;

                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              // 🔹 Progress Bar
                                                              Container(
                                                                height: 13,
                                                                width: barWidth,
                                                                decoration: BoxDecoration(
                                                                  color: AppColor.bgRed,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                              ),

                                                              // 🔹 Elevation Text (same row)
                                                              Text(
                                                                split['elevation'].toString(),
                                                                style: CustomTextStyles.regular(fontSize: 14),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),

                                            // Expanded(
                                            //   child: Row(
                                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //     children: [
                                            //       Column(
                                            //         children: [
                                            //           for (var split in splits) ...[
                                            //             Builder(
                                            //               builder: (context) {
                                            //                 double paceInSec = paceToSeconds(split['pace'].toString());
                                            //                 double ratio = paceInSec / maxPaceInSec; // 0 → 1
                                            //                 double barWidth = maxBarWidth * ratio;
                                            //                 return Padding(
                                            //                   padding: const EdgeInsets.only(bottom: 10),
                                            //                   child: Container(
                                            //                     margin: EdgeInsets.only(top: 3, bottom: 3),
                                            //                     height: 13,
                                            //                     width: barWidth,
                                            //                     decoration: BoxDecoration(
                                            //                       color: AppColor.bgRed,
                                            //                       borderRadius: BorderRadius.circular(12),
                                            //                     ),
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             ),
                                            //           ],
                                            //         ],
                                            //       ),
                                            //       Column(
                                            //         children: [
                                            //           for (var elevation in splits) ...[
                                            //             Text(elevation['elevation'].toString(), style: CustomTextStyles.regular(fontSize: 14)),
                                            //             const SizedBox(height: 10),
                                            //           ],
                                            //         ],
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ]
                                  ),
                                ),
                                const SizedBox(height: 20),

                                Divider(color: Colors.grey.shade300,),
                                const SizedBox(height: 20),

                                Container(
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
                                      buildPaceChart(feedData.splitStr.toString()),

                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Avg Pace', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${Constant.formatPace(double.parse(feedData.pace.toString()))} /Km', style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Moving Time', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text(Constant.formatDuration(int.parse(feedData.movingTime.toString())), style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Avg Elapsed Pace', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${Constant.formatPace(double.parse(feedData.avgElapsedPace.toString()))}/Km', style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Elapsed Time', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${feedData.elapsedTime}', style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Fastest Split', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${Constant.formatPace(double.parse(feedData.fastestSplit.toString()))} /Km', style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                Divider(color: Colors.grey.shade300,),
                                const SizedBox(height: 20),
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

                                  feedData.elavationStr == null
                                      ? SizedBox()
                                      : buildElevationChart(feedData.splitStr.toString()),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Elevation Gain', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${feedData.elavationGain}m', style: CustomTextStyles.regular(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Max Elevation', style: CustomTextStyles.regular(fontSize: 14)),
                                          Text('${feedData.maxElavation}m', style: CustomTextStyles.regular(fontSize: 16)),
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
                      )
                    );
                  },
                ),
              ],
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
  final CrossAxisAlignment cross;

  const _InfoColumn({required this.title, required this.value, required this.cross});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: cross,
      children: [

        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}