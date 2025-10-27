// import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
// import 'package:coherent_endurance/constant/Constant.dart';
// import 'package:coherent_endurance/models/profileModel.dart';
// import 'package:coherent_endurance/resources/color/appColor.dart';
// import 'package:coherent_endurance/resources/image/appImages.dart';
// import 'package:coherent_endurance/resources/style/textStyle.dart';
// import 'package:coherent_endurance/ui/allChallenges/myAllChallenges.dart';
// import 'package:coherent_endurance/ui/search/searchScreen.dart';
// import 'package:coherent_endurance/ui/trophyCase.dart';
// import 'package:coherent_endurance/ui/profileScreens/activitiesScreen.dart';
// import 'package:coherent_endurance/ui/profileScreens/editProfileScreen.dart';
// import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
// import 'package:coherent_endurance/ui/profileScreens/statisticsScreen.dart';
// import 'package:coherent_endurance/widgets/backButton.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final String path;
//   ProfileScreen({this.path = 'user', super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   int selectedWeekIndex = 0;
//   List<Map<String, String>> milestone = [
//     {"image": AppImageOthers.milestone, "title": "December 5K",},
//     {"image": AppImageOthers.milestone, "title": "December 5K",},
//     {"image": AppImageOthers.milestone, "title": "December 5K"},
//   ];
//
//   //ProfileModel? profileData;
//   String selectedValue = Constant.getCategory!.data!.first.categoryName.toString(); // default selected
//   late final String categoryId ;
//
//   @override
//   void initState() {
//     //profileData = Constant.getProfile;
//
//      categoryId = Constant.getCategory!.data!.first.categoryId.toString();
//     print('categoryId::::$categoryId');
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: BlocConsumer<ProfileBloc, ProfileState>(
//           listener: (context, state) {
//             // TODO: implement listener
//       if(state is ProfileSuccess){
//
//       }
//           },
//           builder: (context, state) {
//             if(state is ProfileLoading){
//               return Center(
//                 child: LoadingAnimationWidget.inkDrop(
//                   color: AppColor.bgRed,
//                   size: 20,
//                 ),
//               );
//             }
//             if(state is ProfileSuccess){
//               var profileData = state.profileModel!;
//               final summaryData = state.summaryModel?.data;
//               final activities = summaryData?.thisWeekActivities ?? [];
//               // var activity = selectedWeekIndex != null ? activities[selectedWeekIndex] : null;
//               final activity = (selectedWeekIndex != null && selectedWeekIndex < activities.length)
//                   ? activities[selectedWeekIndex]
//                   : null;
//               final trophies = state.summaryModel?.data?.userTrophies ?? [];
//               final challenges = state.summaryModel?.data?.userChallenges ?? [];
//
//
//               return Column(
//                 children: [
//                   Stack(
//                     children: [
//                       // Image.asset(AppImageOthers.user),
//                       Container(
//                         height: 210,
//                       ),
//                       Container(
//                         color: AppColor.bgRed,
//                         child: Column(
//                           children: [
//                             SizedBox(height: 40,),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                         margin: EdgeInsets.symmetric(horizontal: 10),
//                                         height: 55,
//                                         width: 55,
//                                         child: GestureDetector(
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: BackButtonWidget(arrowColor: Colors.black, backgroundColor: Colors.white,))),
//
//                                     SizedBox(width: 10,),
//                                     // Text('Profile', style: CustomTextStyles.bold(fontSize: 18),)
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                   child: Row(
//                                     children: [
//                                       widget.path == 'user' ? GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
//                                           },
//                                           child: Image.asset('assets/image/others/profileSearch.png', height: 28,)
//                                       ) : SizedBox(),
//                                       SizedBox(width: 10,),
//                                       GestureDetector(
//                                           onTap: () {
//                                             // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
//                                           },
//                                           child: Icon(Icons.share, color: Colors.white,)),
//
//                                       SizedBox(width: 10,),
//
//                                       widget.path == 'user' ? GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
//                                           },
//                                           child: Icon(Icons.settings, color: Colors.white,)/*SvgPicture.asset(AppImageSvg.setting)*/
//                                       ) : IconButton(
//                                         icon: Icon(Icons.more_vert, color: Colors.white,),
//                                         onPressed: () => _showCupertinoMenu(context),
//                                       ),
//
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//
//
//                       Positioned(
//                         bottom: 20,
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: 100,
//                               width: MediaQuery.of(context).size.width,
//                               color: AppColor.bgRed,
//                             ),
//                             Positioned(
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 45,
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(30),
//                                           topRight: Radius.circular(30)
//                                       ),
//                                       color: Colors.white
//                                   ),
//                                 )
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.red, width: 1),
//                                   ),
//                                   child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: CachedNetworkImage(
//                                         imageUrl: profileData!.data!.profilePhoto.toString(),
//                                         width: 90.0,
//                                         height: 90.0,
//                                         fit: BoxFit.fill,
//                                         placeholder:
//                                             (context, url) =>
//                                             Padding(
//                                               padding:
//                                               EdgeInsets.all(
//                                                   40.0),
//                                               child:
//                                               CircularProgressIndicator(
//                                                 color: AppColor.bgRed,
//                                                 strokeWidth: 1,
//                                               ),
//                                             ),
//                                         errorWidget: (context,
//                                             url, error) =>
//                                             Image.asset(AppImageOthers.profilePic, height: 90,),
//                                       )
//                                   ),
//                                 ),
//                               ),
//                             )
//
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         child: Container(
//                           height: 60,
//                           color: AppColor.bgRed,
//                         ),
//                       ),
//                       widget.path == 'user' ? Positioned(
//                           right: 15,
//                           bottom: 20,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
//                             },
//                             child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: AppColor.bgRed
//                                 ),
//                                 child: Icon(Icons.edit, size: 18, color: Colors.white,)),
//                           )
//                       ) : SizedBox()
//
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                     child: Column(
//                       children: [
//                         Text('${profileData!.data!.firstName ?? 'User'} ${profileData!.data!.lastName ?? ''}', style: CustomTextStyles.bold(fontSize: 26 ),),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.location_on,),
//                             Text('${profileData!.data!.city ?? ''} ${profileData!.data!.state ?? ''}'
//                                 ' ${profileData!.data!.country ?? ''}',
//                               style: CustomTextStyles.medium(fontSize: 17),),
//                           ],
//                         ),
//                         SizedBox(height: 12,),
//                         Text(profileData!.data!.bio ?? 'No Bio',
//                           style: TextStyle(fontSize: 11 ), textAlign: TextAlign.center,),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Text(profileData!.data!.totalFollowers.toString(), style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
//                               Text('Follower', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(width: 10,),
//                       SvgPicture.asset(AppImageSvg.verticalLine),
//                       SizedBox(width: 10,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Text(profileData!.data!.totalFollowing.toString(), style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
//                               Text('Following', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   widget.path == 'user' ? SizedBox() : Column(
//                     children: [
//                       SizedBox(height: 20,),
//                       Container(
//                         height: 25,
//                         width: 80,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: AppColor.bgRed
//                         ),
//                         child: Center(
//                           child: Text('Follow', style: TextStyle(color: Colors.white),),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20,),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             color: AppColor.bgTile,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(height: 10,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('This week', style: CustomTextStyles.semiBold(fontSize: 16),),
//                                       PopupMenuButton<String>(
//                                         initialValue: selectedValue,
//                                         onSelected: (value) {
//                                           setState(() {
//                                             selectedValue = value;
//                                           });
//                                           final selectCategory = Constant.getCategory!.data!.firstWhere(
//                                                 (e) => e.categoryName == selectedValue,);
//                                           final categoryId = selectCategory.categoryId.toString();
//                                           context.read<ProfileBloc>().add(GetProfileSummary(context, categoryId.toString() ));
//                                         },
//                                         color: Colors.white,
//                                         itemBuilder: (BuildContext context) {
//                                           return Constant.getCategory!.data!.map((category) {
//                                             final isSelected = selectedValue == category.categoryName;
//                                             return PopupMenuItem<String>(
//                                               value: category.categoryName,
//                                               child: SizedBox(
//                                                 width: 100,
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Image.network(category.categoryIcon.toString(),
//                                                           height: 18,
//                                                           color: isSelected ? Colors.red : Colors.black,),
//                                                         const SizedBox(width: 8),
//                                                         Text(
//                                                           category.categoryName.toString(),
//                                                           style: TextStyle(
//                                                             color: isSelected ? Colors.red : Colors.black,
//                                                             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     if (isSelected)
//                                                       Icon(Icons.check, color: isSelected ? Colors.red : Colors.black),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           }).toList();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20,),
//                                   SizedBox(
//                                     width: 200,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text('Distance', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
//                                             // Text('${double.parse(activity.distance.toString())/1000} km', style: CustomTextStyles.regular(fontSize: 16 )),
//
//                                             Text(
//                                               activity != null ? "${(double.parse(activity.distance.toString())/1000).toStringAsFixed(1)} km" : "--",
//                                               style: CustomTextStyles.regular(fontSize: 16),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text('Pace', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
//                                             // Text('${activity.pace}', style: CustomTextStyles.regular(fontSize: 16 )),
//
//                                             Text(
//                                               activity != null ? "${activity.pace}" : "--",
//                                               style: CustomTextStyles.regular(fontSize: 16),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text('Elev Gain', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
//                                             // Text('${activity.elavationGain}', style: CustomTextStyles.regular(fontSize: 16 )),
//
//                                             Text(
//                                               activity != null ? "${activity.elavationGain}" : "--",
//                                               style: CustomTextStyles.regular(fontSize: 16),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 20,),
//                                   // Container(
//                                   //   height: 200,
//                                   //   color: AppColor.bgTile, // background color
//                                   //   padding: const EdgeInsets.all(8),
//                                   //   child: LineChart(
//                                   //     LineChartData(
//                                   //       backgroundColor: AppColor.bgTile,
//                                   //       gridData: FlGridData(show: false), // grid lines hide
//                                   //       titlesData: FlTitlesData(
//                                   //         leftTitles: AxisTitles(
//                                   //           sideTitles: SideTitles(
//                                   //             showTitles: true,
//                                   //             reservedSize: 40,
//                                   //             getTitlesWidget: (value, meta) {
//                                   //               return Text(
//                                   //                 '${value.toInt()} km',
//                                   //                 style: const TextStyle(color: Colors.black, fontSize: 10),
//                                   //               );
//                                   //             },
//                                   //           ),
//                                   //         ),
//                                   //         bottomTitles: AxisTitles(
//                                   //           sideTitles: SideTitles(
//                                   //             showTitles: true,
//                                   //             reservedSize: 30,
//                                   //             getTitlesWidget: (value, meta) {
//                                   //               return Text(
//                                   //                 '${value.toInt()} m',
//                                   //                 style: const TextStyle(color: Colors.black, fontSize: 10),
//                                   //               );
//                                   //             },
//                                   //           ),
//                                   //         ),
//                                   //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                   //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                   //       ),
//                                   //       borderData: FlBorderData(
//                                   //         show: true,
//                                   //         border: Border.all(color: Colors.grey, width: 0.5),
//                                   //       ),
//                                   //       lineBarsData: [
//                                   //         LineChartBarData(
//                                   //           spots: const [
//                                   //             FlSpot(0, 0),
//                                   //             FlSpot(1, 0),
//                                   //             FlSpot(2, 0),
//                                   //             FlSpot(3, 2),
//                                   //             FlSpot(4, 0),
//                                   //             FlSpot(5, 0),
//                                   //             FlSpot(6, 0),
//                                   //           ],
//                                   //           isCurved: false,
//                                   //           color: Colors.redAccent,
//                                   //           barWidth: 2,
//                                   //           dotData: FlDotData(show: true),
//                                   //           belowBarData: BarAreaData(show: false),
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   Container(
//                                     // padding: const EdgeInsets.symmetric(vertical: 10),
//                                     height: 180,
//                                     child: LineChart(
//                                       LineChartData(
//                                         gridData: FlGridData(show: false),
//                                         titlesData: FlTitlesData(
//                                           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                           leftTitles: AxisTitles(
//                                             sideTitles: SideTitles(
//                                               showTitles: true,
//                                               reservedSize: 50,
//                                               interval: 50, // ✅ हर 50 km पर tick
//                                               getTitlesWidget: (value, meta) {
//                                                 return Align(
//                                                   alignment: Alignment.topRight,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                                                     child: Text(
//                                                       "${value.toInt()} km",
//                                                       style: const TextStyle(
//                                                         fontSize: 10,   // ✅ font size 10
//                                                         color: Colors.black, // optional
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ),
//
//                                           // leftTitles: AxisTitles(
//                                           //   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                                           // ),
//                                           bottomTitles: AxisTitles(
//                                             sideTitles: SideTitles(
//                                               showTitles: false,
//                                               getTitlesWidget: (value, meta) {
//                                                 if (value.toInt() < activities.length) {
//                                                   final week = activities[value.toInt()];
//                                                   return Text(
//                                                     "${DateTime.parse(week.startDate!).day}", // सिर्फ़ दिन show किया
//                                                     style: const TextStyle(fontSize: 10),
//                                                   );
//                                                 }
//                                                 return const Text("");
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                         // borderData: FlBorderData(show: false),
//                                         // ✅ अब maxY को round figure तक ले जाएंगे
//                                         minY: 0,
//                                         // maxY: () {
//                                         //   double maxDist = activities
//                                         //       .map((e) => double.parse(e.distance.toString()) / 1000)
//                                         //       .reduce((a, b) => a > b ? a : b);
//                                         //
//                                         //   // ✅ अब maxDist को अगले 50 के multiple तक round कर देंगे
//                                         //   int rounded = ((maxDist / 50).ceil() * 50);
//                                         //   return rounded.toDouble();
//                                         // }(),
//                                         maxY: () {
//                                           if (activities.isEmpty) {
//                                             return 0.0; // ✅ default value अगर कोई data नहीं है
//                                           }
//                                           double maxDist = activities
//                                               .map((e) => double.parse(e.distance.toString()) / 1000)
//                                               .reduce((a, b) => a > b ? a : b);
//
//                                           int rounded = ((maxDist / 50).ceil() * 50);
//                                           return rounded.toDouble();
//                                         }(),
//                                         borderData: FlBorderData(
//                                           show: true,
//                                           border: Border.all(color: Colors.grey, width: 0.5),
//                                         ),
//                                         lineBarsData: [
//                                           LineChartBarData(
//                                             spots: activities.asMap().entries.map((e) {
//                                               return FlSpot(e.key.toDouble(), double.parse(e.value.distance.toString())/1000);
//                                             }).toList(),
//                                             isCurved: false,
//                                             color: Colors.redAccent,
//                                             barWidth: 2,
//                                             dotData: FlDotData(show: true),
//                                           ),
//                                         ],
//
//                                         // 👇 Handle Touch
//                                         lineTouchData: LineTouchData(
//                                           enabled: true,
//                                           touchCallback: (event, response) {
//                                             if (response != null &&
//                                                 response.lineBarSpots != null &&
//                                                 response.lineBarSpots!.isNotEmpty) {
//                                               setState(() {
//                                                 selectedWeekIndex = response.lineBarSpots!.first.x.toInt();
//                                               });
//                                             }
//                                           },
//                                           touchTooltipData: LineTouchTooltipData(
//                                             tooltipBgColor: Colors.black54,
//                                             getTooltipItems: (touchedSpots) {
//                                               return touchedSpots.map((spot) {
//                                                 final activity = activities[spot.x.toInt()];
//                                                 return LineTooltipItem(
//                                                   "Dist: ${double.parse(activity.distance.toString())/1000} km\n"
//                                                       "Pace: ${activity.pace}\n"
//                                                       "Elev: ${activity.elavationGain}",
//                                                   const TextStyle(color: Colors.white),
//                                                 );
//                                               }).toList();
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 40,)
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Column(
//                               children: [
//                                 ListTile(
//                                   contentPadding: EdgeInsets.zero,
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesScreen()));
//                                   },
//                                   leading: SvgPicture.asset(AppImageSvg.activities),
//                                   title: Text('Activities', style: CustomTextStyles.semiBold(fontSize: 14 )),
//                                   subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
//                                   trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
//                                 ),
//                                 ListTile(
//                                   contentPadding: EdgeInsets.zero,
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsScreen()));
//
//                                   },
//                                   leading: SvgPicture.asset(AppImageSvg.statistics),
//                                   title: Text('Statistics', style: CustomTextStyles.semiBold(fontSize: 14 )),
//                                   subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
//                                   trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
//                                 ),
//                                 ListTile(
//                                   contentPadding: EdgeInsets.zero,
//                                   onTap: () {
//                                     //Navigator.push(context, MaterialPageRoute(builder: (context) => TrophyCase()));
//
//                                   },
//                                   leading: SvgPicture.asset(AppImageSvg.trophy),
//                                   title: Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 14 )),
//                                   subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey )),
//                                   trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
//                                 ),
//                                 SizedBox(height: 20,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 16),),
//                                     Text('3', style: CustomTextStyles.regular(fontSize: 16)),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20,),
//
//                                 buildBadgeGrid(milestone),
//
//                                 SizedBox(height: 10,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('All Trophies', style: TextStyle(fontSize: 16)/*CustomTextStyles.regular(fontSize: 16)*/,),
//                                     Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
//                                   ],
//                                 ),
//                                 SizedBox(height: 10,),
//
//                                 Divider(height: 20,color: AppColor.bgTile,thickness: 2,),
//
//                                 SizedBox(height: 10,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Challenges', style: CustomTextStyles.semiBold(fontSize: 16),),
//                                     Text('1', style: CustomTextStyles.regular(fontSize: 16)),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20,),
//                                 ListTile(
//                                   contentPadding: EdgeInsets.zero,
//                                   leading: SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
//                                   title: Text('Timeout Streaks Challenge\nJuly 2025'),
//                                   subtitle: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
//                                           Text(' --/4 weeks', style: TextStyle(color: Colors.grey),)
//                                         ],
//                                       ),
//                                       Text('10 days left', style: TextStyle(color: Colors.grey))
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 GestureDetector(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => MyAllChallenges(categoryID: categoryId,)));
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text('All Challenge', style: CustomTextStyles.regular(textColor: AppColor.bgRed),)
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//
//                                 Divider(height: 20,color: AppColor.bgTile,thickness: 2,),
//
//                                 SizedBox(height: 10,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Clubs', style: CustomTextStyles.semiBold(fontSize: 16),),
//                                     Text('2', style: CustomTextStyles.regular(fontSize: 16)),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20,),
//                                 GridView.builder(
//                                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 2,
//                                       mainAxisSpacing: 8,
//                                       crossAxisSpacing: 8,
//                                       mainAxisExtent: 110
//                                   ),
//                                   padding: EdgeInsets.symmetric(vertical: 10),
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: 2,
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         color: AppColor.bgTile,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Center(child: Image.asset(AppImageOthers.clubDP, height: 55,)),
//                                           SizedBox(height: 5),
//                                           Text('Pinkcity Runners', style: CustomTextStyles.semiBold(fontSize: 15),),
//
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text('All clubs', style: CustomTextStyles.regular(textColor: AppColor.bgRed),)
//                                   ],
//                                 ),
//                                 SizedBox(height: 10,),
//                               ],
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             if(state is ProfileError){
//               return Center(
//                 child: Text(state.error),
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ),
//
//     );
//   }
//
//
//   Widget buildBadgeGrid(List<Map<String, String>> badges) {
//     List<Widget> rows = [];
//
//     for (int i = 0; i < badges.length; i += 3) {
//       final rowItems = badges.skip(i).take(3).toList();
//
//       rows.add(
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 8),
//           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: rowItems.map((badge) {
//               return Column(
//                 children: [
//                   Image.asset(
//                     badge["image"]!,
//                     height: 75, width: 70,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     badge["title"]!,
//                     style: CustomTextStyles.semiBold(fontSize: 12),
//                   ),
//
//                   if (badge["subTitle"] != null && badge["subTitle"]!.isNotEmpty)
//                     Text(
//                       badge['subTitle']!,
//                       style: CustomTextStyles.regular(fontSize: 12),
//                     )
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       );
//     }
//
//     return Column(children: rows);
//   }
//
//   void _showCupertinoMenu(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) => CupertinoActionSheet(
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.pop(context);
//
//             },
//             isDefaultAction: true,
//             child: Text(
//               "Report Profile",
//               style: TextStyle(color: Colors.blue, fontSize: 16),
//             ),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             isDestructiveAction: true,
//             child: Text(
//               "Block",
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(
//             "Cancel",
//             style: TextStyle(color: Colors.blue, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/profileModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/active/challangesActive.dart';
import 'package:coherent_endurance/ui/profileScreens/allChallenge.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/ui/trophyCase.dart';
import 'package:coherent_endurance/ui/profileScreens/activitiesScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/editProfileScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/statisticsScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/summaryModel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  final String path;
  ProfileScreen({this.path = 'user', super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedWeekIndex = 0;
  List<Map<String, String>> milestone = [
    {"image": AppImageOthers.milestone, "title": "December 5K",},
    {"image": AppImageOthers.milestone, "title": "December 5K",},
    {"image": AppImageOthers.milestone, "title": "December 5K"},
  ];

  ProfileModel? profileData;
  String selectedValue = Constant.getCategory!.data!.first.categoryName.toString(); // default selected
  String categoryId = '';

  @override
  void initState() {
    //profileData = Constant.getProfile;
    context.read<ProfileBloc>().add(GetProfileEvent(context, ''));
     categoryId = Constant.getCategory!.data!.first.categoryId.toString();
    print('categoryId::::$categoryId');
    context.read<ProfileBloc>().add(GetProfileSummary(context, categoryId));
    super.initState();
  }

  String getCurrentFormattedDate() {
    final now = DateTime.now();
    return DateFormat('MMMM d, y').format(now); // July 12, 2025
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if(state is ProfileLoading){
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: AppColor.bgRed,
                  size: 20,
                ),
              );
            }
            if(state is ProfileSuccess){
              var profileData = state.profileModel!;
              final summaryData = state.summaryModel?.data;
              final activities = state.summaryModel?.data?.thisWeekActivities ?? [];
              // var activity = selectedWeekIndex != null ? activities[selectedWeekIndex] : null;
              final activity = (selectedWeekIndex != null && selectedWeekIndex < activities.length)
                  ? activities[selectedWeekIndex]
                  : null;
              final trophies = state.summaryModel?.data?.userTrophies ?? [];
              final challenges = state.summaryModel?.data?.userChallenges ?? [];

              return Column(
                children: [
                  Stack(
                    children: [
                      // Image.asset(AppImageOthers.user),
                      Container(
                        height: 210,
                      ),
                      Container(
                        color: AppColor.bgRed,
                        child: Column(
                          children: [
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        height: 55,
                                        width: 55,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: BackButtonWidget(arrowColor: Colors.black, backgroundColor: Colors.white,))),

                                    SizedBox(width: 10,),
                                    // Text('Profile', style: CustomTextStyles.bold(fontSize: 18),)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      widget.path == 'user' ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                          },
                                          child: Image.asset('assets/image/others/profileSearch.png', height: 28,)
                                      ) : SizedBox(),
                                      SizedBox(width: 10,),
                                      GestureDetector(
                                          onTap: () {
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));

                                            final link = "https://play.google.com/store/apps/details?id=${}";

                                            Share.share(
                                              "Check out my profile on Dhava 🏃‍♂️:\n$link",
                                              subject: "My Profile",
                                            );

                                          },
                                          child: Icon(Icons.share, color: Colors.white,)),

                                      SizedBox(width: 10,),

                                      widget.path == 'user' ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                          },
                                          child: Icon(Icons.settings, color: Colors.white,)/*SvgPicture.asset(AppImageSvg.setting)*/
                                      ) : IconButton(
                                        icon: Icon(Icons.more_vert, color: Colors.white,),
                                        onPressed: () => _showCupertinoMenu(context),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),


                      Positioned(
                        bottom: 20,
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              color: AppColor.bgRed,
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)
                                      ),
                                      color: Colors.white
                                  ),
                                )
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.red, width: 1),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: context.read<ProfileBloc>().profileModel?.data?.profilePhoto ?? '',
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.fill,
                                        placeholder:
                                            (context, url) =>
                                            Padding(
                                              padding:
                                              EdgeInsets.all(
                                                  40.0),
                                              child:
                                              CircularProgressIndicator(
                                                color: AppColor.bgRed,
                                                strokeWidth: 1,
                                              ),
                                            ),
                                        errorWidget: (context,
                                            url, error) =>
                                            Image.asset(AppImageOthers.defaultImage,width: 90,
                                              height: 90,),
                                      )
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 60,
                          color: AppColor.bgRed,
                        ),
                      ),
                      widget.path == 'user' ? Positioned(
                          right: 15,
                          bottom: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                            },
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor.bgRed
                                ),
                                child: Icon(Icons.edit, size: 18, color: Colors.white,)),
                          )
                      ) : SizedBox()

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Text('${profileData!.data!.firstName ?? 'User'} ${profileData!.data!.lastName ?? ''}', style: CustomTextStyles.bold(fontSize: 26 ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on,),
                            Text('${profileData!.data!.city ?? ''} ${profileData!.data!.state ?? ''}'
                                ' ${profileData!.data!.country ?? ''}',
                              style: CustomTextStyles.medium(fontSize: 17),),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Text(profileData!.data!.bio ?? 'No Bio',
                          style: TextStyle(fontSize: 11 ), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(profileData!.data!.totalFollowers.toString(), style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
                              Text('Follower', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(width: 10,),
                      SvgPicture.asset(AppImageSvg.verticalLine),
                      SizedBox(width: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(profileData!.data!.totalFollowing.toString(), style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
                              Text('Following', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  widget.path == 'user' ? SizedBox() : Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        height: 25,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.bgRed
                        ),
                        child: Center(
                          child: Text('Follow', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColor.bgTile,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('This week', style: CustomTextStyles.semiBold(fontSize: 16),),
                                      SizedBox(
                                        width: 20,
                                        child: PopupMenuButton<String>(
                                          initialValue: selectedValue,
                                          onSelected: (value) {
                                            setState(() {
                                              selectedValue = value;
                                            });
                                            final selectCategory = Constant.getCategory!.data!.firstWhere(
                                                  (e) => e.categoryName == selectedValue,);
                                            categoryId = selectCategory.categoryId.toString();
                                            context.read<ProfileBloc>().add(GetProfileSummary(context, categoryId.toString() ));
                                          },
                                          color: Colors.white,
                                          itemBuilder: (BuildContext context) {
                                            return Constant.getCategory!.data!.map((category) {
                                              final isSelected = selectedValue == category.categoryName;
                                              return PopupMenuItem<String>(
                                                value: category.categoryName,
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.network(category.categoryIcon.toString(),
                                                            height: 18,
                                                            color: isSelected ? Colors.red : Colors.black,),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            category.categoryName.toString(),
                                                            style: TextStyle(
                                                              color: isSelected ? Colors.red : Colors.black,
                                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (isSelected)
                                                        Icon(Icons.check, color: isSelected ? Colors.red : Colors.black),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Distance', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                            // Text('${double.parse(activity.distance.toString())/1000} km', style: CustomTextStyles.regular(fontSize: 16 )),

                                            Text(
                                              activity != null ? "${(double.parse(activity.distance.toString())/1000).toStringAsFixed(1)} km" : "--",
                                              style: CustomTextStyles.regular(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Pace', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                            // Text('${activity.pace}', style: CustomTextStyles.regular(fontSize: 16 )),

                                            Text(
                                              activity != null ? "${activity.pace}" : "--",
                                              style: CustomTextStyles.regular(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Elev Gain', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                            // Text('${activity.elavationGain}', style: CustomTextStyles.regular(fontSize: 16 )),

                                            Text(
                                              activity != null ? "${activity.elavationGain}" : "--",
                                              style: CustomTextStyles.regular(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  // Container(
                                  //   height: 200,
                                  //   color: AppColor.bgTile, // background color
                                  //   padding: const EdgeInsets.all(8),
                                  //   child: LineChart(
                                  //     LineChartData(
                                  //       backgroundColor: AppColor.bgTile,
                                  //       gridData: FlGridData(show: false), // grid lines hide
                                  //       titlesData: FlTitlesData(
                                  //         leftTitles: AxisTitles(
                                  //           sideTitles: SideTitles(
                                  //             showTitles: true,
                                  //             reservedSize: 40,
                                  //             getTitlesWidget: (value, meta) {
                                  //               return Text(
                                  //                 '${value.toInt()} km',
                                  //                 style: const TextStyle(color: Colors.black, fontSize: 10),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //         bottomTitles: AxisTitles(
                                  //           sideTitles: SideTitles(
                                  //             showTitles: true,
                                  //             reservedSize: 30,
                                  //             getTitlesWidget: (value, meta) {
                                  //               return Text(
                                  //                 '${value.toInt()} m',
                                  //                 style: const TextStyle(color: Colors.black, fontSize: 10),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  //       ),
                                  //       borderData: FlBorderData(
                                  //         show: true,
                                  //         border: Border.all(color: Colors.grey, width: 0.5),
                                  //       ),
                                  //       lineBarsData: [
                                  //         LineChartBarData(
                                  //           spots: const [
                                  //             FlSpot(0, 0),
                                  //             FlSpot(1, 0),
                                  //             FlSpot(2, 0),
                                  //             FlSpot(3, 2),
                                  //             FlSpot(4, 0),
                                  //             FlSpot(5, 0),
                                  //             FlSpot(6, 0),
                                  //           ],
                                  //           isCurved: false,
                                  //           color: Colors.redAccent,
                                  //           barWidth: 2,
                                  //           dotData: FlDotData(show: true),
                                  //           belowBarData: BarAreaData(show: false),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    // padding: const EdgeInsets.symmetric(vertical: 10),
                                    height: 180,
                                    child: LineChart(
                                      LineChartData(
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(
                                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 50,
                                              interval: 50, // ✅ हर 50 km पर tick
                                              getTitlesWidget: (value, meta) {
                                                return Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Text(
                                                      "${value.toInt()} km",
                                                      style: const TextStyle(
                                                        fontSize: 10,   // ✅ font size 10
                                                        color: Colors.black, // optional
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          // leftTitles: AxisTitles(
                                          //   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                                          // ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                              getTitlesWidget: (value, meta) {
                                                if (value.toInt() < activities.length) {
                                                  final week = activities[value.toInt()];
                                                  return Text(
                                                    "${DateTime.parse(week.startDate!).day}", // सिर्फ़ दिन show किया
                                                    style: const TextStyle(fontSize: 10),
                                                  );
                                                }
                                                return const Text("");
                                              },
                                            ),
                                          ),
                                        ),
                                        // borderData: FlBorderData(show: false),
                                        // ✅ अब maxY को round figure तक ले जाएंगे
                                        minY: 0,
                                        // maxY: () {
                                        //   double maxDist = activities
                                        //       .map((e) => double.parse(e.distance.toString()) / 1000)
                                        //       .reduce((a, b) => a > b ? a : b);
                                        //
                                        //   // ✅ अब maxDist को अगले 50 के multiple तक round कर देंगे
                                        //   int rounded = ((maxDist / 50).ceil() * 50);
                                        //   return rounded.toDouble();
                                        // }(),
                                        maxY: () {
                                          if (activities.isEmpty) {
                                            return 0.0; // ✅ default value अगर कोई data नहीं है
                                          }
                                          double maxDist = activities
                                              .map((e) => double.parse(e.distance.toString()) / 1000)
                                              .reduce((a, b) => a > b ? a : b);

                                          int rounded = ((maxDist / 50).ceil() * 50);
                                          return rounded.toDouble();
                                        }(),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(color: Colors.grey, width: 0.5),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: activities.asMap().entries.map((e) {
                                              return FlSpot(e.key.toDouble(), double.parse(e.value.distance.toString())/1000);
                                            }).toList(),
                                            isCurved: false,
                                            color: Colors.redAccent,
                                            barWidth: 2,
                                            dotData: FlDotData(show: true),
                                          ),
                                        ],

                                        // 👇 Handle Touch
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          touchCallback: (event, response) {
                                            if (response != null &&
                                                response.lineBarSpots != null &&
                                                response.lineBarSpots!.isNotEmpty) {
                                              setState(() {
                                                selectedWeekIndex = response.lineBarSpots!.first.x.toInt();
                                              });
                                            }
                                          },
                                          touchTooltipData: LineTouchTooltipData(
                                            tooltipBgColor: Colors.black54,
                                            getTooltipItems: (touchedSpots) {
                                              return touchedSpots.map((spot) {
                                                final activity = activities[spot.x.toInt()];
                                                return LineTooltipItem(
                                                  "Dist: ${double.parse(activity.distance.toString())/1000} km\n"
                                                      "Pace: ${activity.pace}\n"
                                                      "Elev: ${activity.elavationGain}",
                                                  const TextStyle(color: Colors.white),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40,)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesScreen()));
                                  },
                                  leading: SvgPicture.asset(AppImageSvg.activities),
                                  title: Text('Activities', style: CustomTextStyles.semiBold(fontSize: 14 )),
                                  subtitle: Text(getCurrentFormattedDate(), style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                                ),
                                // ListTile(
                                //   contentPadding: EdgeInsets.zero,
                                //   onTap: () {
                                //     Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsScreen()));
                                //
                                //   },
                                //   leading: SvgPicture.asset(AppImageSvg.statistics),
                                //   title: Text('Statistics', style: CustomTextStyles.semiBold(fontSize: 14 )),
                                //   subtitle: Text(getCurrentFormattedDate(), style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                                //   trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                                // ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrophyCase(categoryId: categoryId, userId: '',)));

                                  },
                                  leading: SvgPicture.asset(AppImageSvg.trophy),
                                  title: Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 14 )),
                                  subtitle: Text(getCurrentFormattedDate(), style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey )),
                                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 16),),
                                    // Text('3', style: CustomTextStyles.regular(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 20,),

                                buildBadgeGrid(trophies),

                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('All Trophies', style: TextStyle(fontSize: 16)/*CustomTextStyles.regular(fontSize: 16)*/,),
                                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
                                  ],
                                ),
                                SizedBox(height: 10,),

                                Divider(height: 20,color: AppColor.bgTile,thickness: 2,),

                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Challenges', style: CustomTextStyles.semiBold(fontSize: 16),),
                                    // Text('1', style: CustomTextStyles.regular(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: challenges.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final duration = Constant.calculateChallengeDuration(
                                      challenges[index].startDate,
                                      challenges[index].endDate,
                                    );
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesActiveScreen(challengeId: challenges[index].challengeId.toString(),)));
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: (challenges[index].challengeIcon != null && challenges[index].challengeIcon != 'null' &&
                                          challenges[index].challengeIcon!.isNotEmpty)
                                          ? CachedNetworkImage(
                                        imageUrl: challenges[index].challengeIcon!,
                                        height: 50,
                                        width: 50,
                                        imageBuilder: (context, imageProvider) => ClipOval(
                                          child: Image(
                                            image: imageProvider,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        placeholder: (context, url) => ClipOval(
                                          child: SvgPicture.asset(
                                            AppImageSvg.activeUser,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => ClipOval(
                                          child: SvgPicture.asset(
                                            AppImageSvg.activeUser,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                          : ClipOval(
                                        child: SvgPicture.asset(
                                          AppImageSvg.activeUser,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      title: Text(challenges[index].title.toString()/*'Timeout Streaks Challenge\nJuly 2025'*/),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.network(challenges[index].categoryIcon.toString(), height: 15, color: Colors.grey,),
                                              Text(' --/${duration['weeks']} weeks', style: TextStyle(color: Colors.grey),)
                                            ],
                                          ),
                                          Text('${duration['daysLeft']} days left', style: TextStyle(color: Colors.grey))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AllChallenge(userId: '',)));
                                        },
                                        child: Text('All Challenge', style: CustomTextStyles.regular(textColor: AppColor.bgRed),))
                                  ],
                                ),
                                SizedBox(height: 10,),

                                // Divider(height: 20,color: AppColor.bgTile,thickness: 2,),
                                //
                                // SizedBox(height: 10,),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text('Clubs', style: CustomTextStyles.semiBold(fontSize: 16),),
                                //     Text('2', style: CustomTextStyles.regular(fontSize: 16)),
                                //   ],
                                // ),
                                // SizedBox(height: 20,),
                                // GridView.builder(
                                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //       crossAxisCount: 2,
                                //       mainAxisSpacing: 8,
                                //       crossAxisSpacing: 8,
                                //       mainAxisExtent: 110
                                //   ),
                                //   padding: EdgeInsets.symmetric(vertical: 10),
                                //   shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   itemCount: 2,
                                //   itemBuilder: (context, index) {
                                //     return Container(
                                //       padding: EdgeInsets.all(10),
                                //       decoration: BoxDecoration(
                                //         color: AppColor.bgTile,
                                //         borderRadius: BorderRadius.circular(12),
                                //       ),
                                //       child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         children: [
                                //           Center(child: Image.asset(AppImageOthers.clubDP, height: 55,)),
                                //           SizedBox(height: 5),
                                //           Text('Pinkcity Runners', style: CustomTextStyles.semiBold(fontSize: 15),),
                                //
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Text('All clubs', style: CustomTextStyles.regular(textColor: AppColor.bgRed),)
                                //   ],
                                // ),
                                // SizedBox(height: 10,),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            if(state is ProfileError){
              return Center(
                child: Text(state.error),
              );
            }
            return SizedBox();
          },
        ),
      ),

    );
  }



  // Widget buildBadgeGrid(List<UserTrophies> badges) {
  //   List<Widget> rows = [];
  //
  //   for (int i = 0; i < badges.length; i += 3) {
  //     final rowItems = badges.skip(i).take(3).toList();
  //
  //     rows.add(
  //       Container(
  //         margin: EdgeInsets.symmetric(vertical: 8),
  //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //         decoration: BoxDecoration(
  //           color: Colors.grey.shade200,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: rowItems.map((badge) {
  //             return Column(
  //               children: [
  //                 Image.asset(
  //                   badge.trophyIcon!,
  //                   height: 75, width: 70,
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   badge.title!,
  //                   style: CustomTextStyles.semiBold(fontSize: 12),
  //                 ),
  //
  //                 // if (badge["subTitle"] != null && badge["subTitle"]!.isNotEmpty)
  //                 //   Text(
  //                 //     badge['subTitle']!,
  //                 //     style: CustomTextStyles.regular(fontSize: 12),
  //                 //   )
  //               ],
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return Column(children: rows);
  // }

  Widget buildBadgeGrid(List<UserTrophies> badges) {
    List<Widget> rows = [];

    for (int i = 0; i < badges.length; i += 3) {
      final rowItems = badges.skip(i).take(3).toList();

      rows.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowItems.map((badge) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🏆 Trophy Image
                    badge.trophyIcon != null && badge.trophyIcon!.isNotEmpty
                        ? Image.network(
                      badge.trophyIcon!,
                      height: 75,
                      width: 70,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.emoji_events, size: 50, color: Colors.grey);
                      },
                    )
                        : const Icon(Icons.emoji_events, size: 50, color: Colors.grey),

                    const SizedBox(height: 8),

                    // 🏷️ Title
                    Text(
                      badge.title ?? "",
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.semiBold(fontSize: 12),
                    ),

                    // 📜 Optional Description
                    // if (badge.description != null && badge.description!.isNotEmpty)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 4),
                    //     child: Text(
                    //       badge.description!,
                    //       textAlign: TextAlign.center,
                    //       style: CustomTextStyles.regular(fontSize: 12),
                    //     ),
                    //   ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }


  void _showCupertinoMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);

            },
            isDefaultAction: true,
            child: Text(
              "Report Profile",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: Text(
              "Block",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      ),
    );
  }

}