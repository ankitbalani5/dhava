import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/ui/trophyCase.dart';
import 'package:coherent_endurance/ui/profileScreens/activitiesScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/editProfileScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/statisticsScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../resources/color/appColor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  List<Map<String, String>> milestone = [
    {"image": AppImageOthers.milestone, "title": "December 5K",},
    {"image": AppImageOthers.milestone, "title": "December 5K",},
    {"image": AppImageOthers.milestone, "title": "December 5K"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                                margin: EdgeInsets.symmetric(horizontal: 4),
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
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                    },
                                    child: Image.asset('assets/image/others/profileSearch.png', height: 28,)),
                                SizedBox(width: 10,),
                                GestureDetector(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                    },
                                    child: Icon(Icons.share, color: Colors.white,)/*SvgPicture.asset(AppImageSvg.setting)*/),
                                // SizedBox(width: 10,),
                                // SvgPicture.asset(AppImageSvg.option),
                                SizedBox(width: 10,),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                    },
                                    child: Icon(Icons.settings, color: Colors.white,)/*SvgPicture.asset(AppImageSvg.setting)*/),

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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(AppImageOthers.profilePic, height: 90,),
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
                Positioned(
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
                )

                // Positioned(
                //   bottom: 10,
                //     left: 0,
                //     right: 0,
                //     child: Column(
                //       children: [
                //         Text('Adam Smith', style: CustomTextStyles.bold(fontSize: 26 ),),
                //         Text('Jaipur, India', style: CustomTextStyles.medium(fontSize: 17),),
                //       ],
                //     )
                // )
              ],
            ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Text('Adam Smith', style: CustomTextStyles.bold(fontSize: 26 ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,),
                          Text('Jaipur, India', style: CustomTextStyles.medium(fontSize: 17),),
                        ],
                      ),
                      SizedBox(height: 12,),
                      Text('Weekend warrior chasing miles and smiles. From 5Ks to marathons,'
                          ' I run for the joy, the challenge, and the community.'
                          ' Always chasing that next PR — and the perfect sunrise run.',
                        style: TextStyle(fontSize: 11/*, color: Colors.grey,*/ ), textAlign: TextAlign.center,),
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
                        Text('500', style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
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
                        Text('500', style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.black),),
                        Text('Following', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
                      ],
                    )
                  ],
                ),
              ],
            ),
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
                            Text('This week', style: CustomTextStyles.semiBold(fontSize: 16),),
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
                                      Text('0 km', style: CustomTextStyles.regular(fontSize: 16 )),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Pace', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                      Text('0 m', style: CustomTextStyles.regular(fontSize: 16 )),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Elev Gain', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                      Text('0 m', style: CustomTextStyles.regular(fontSize: 16 )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 200,
                              color: AppColor.bgTile, // background color
                              padding: const EdgeInsets.all(8),
                              child: LineChart(
                                LineChartData(
                                  backgroundColor: Colors.white,
                                  gridData: FlGridData(show: false), // grid lines hide
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()} km',
                                            style: const TextStyle(color: Colors.black, fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()} m',
                                            style: const TextStyle(color: Colors.black, fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: Colors.grey, width: 0.5),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 0),
                                        FlSpot(1, 0),
                                        FlSpot(2, 0),
                                        FlSpot(3, 2),
                                        FlSpot(4, 0),
                                        FlSpot(5, 0),
                                        FlSpot(6, 0),
                                      ],
                                      isCurved: false,
                                      color: Colors.redAccent,
                                      barWidth: 2,
                                      dotData: FlDotData(show: true),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsScreen()));

                            },
                            leading: SvgPicture.asset(AppImageSvg.statistics),
                            title: Text('Statistics', style: CustomTextStyles.semiBold(fontSize: 14 )),
                            subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TrophyCase()));

                            },
                            leading: SvgPicture.asset(AppImageSvg.trophy),
                            title: Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 14 )),
                            subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey )),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 16),),
                              Text('3', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20,),

                          buildBadgeGrid(milestone),
                          // Column(
                          //   children: [
                          //     Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.white24,
                          //           borderRadius: BorderRadius.circular(12)
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Column(
                          //               children: [
                          //                 Image.asset(AppImageOthers.milestone, height: 75),
                          //                 SizedBox(height: 10,),
                          //                 Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                          //               ],
                          //             ),
                          //             Column(
                          //               children: [
                          //                 Image.asset(AppImageOthers.milestone, height: 75),
                          //                 SizedBox(height: 10,),
                          //                 Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                          //               ],
                          //             ),
                          //             Column(
                          //               children: [
                          //                 Image.asset(AppImageOthers.milestone, height: 75),
                          //                 SizedBox(height: 10,),
                          //                 Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('All Trophies', style: TextStyle(fontSize: 16)/*CustomTextStyles.regular(fontSize: 16)*/,),
                              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
                            ],
                          ),

                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Challenges', style: CustomTextStyles.semiBold(fontSize: 16),),
                              Text('1', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
                            title: Text('Timeout Streaks Challenge\nJuly 2025'),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                                    Text(' --/4 weeks', style: TextStyle(color: Colors.grey),)
                                  ],
                                ),
                                Text('10 days left', style: TextStyle(color: Colors.grey))
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('All Challenge', style: CustomTextStyles.regular(textColor: AppColor.bgRed),)
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Clubs', style: CustomTextStyles.semiBold(fontSize: 16),),
                              Text('2', style: CustomTextStyles.regular(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 110
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(), // ✅ Important
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColor.bgTile,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Image.asset(AppImageOthers.clubDP, height: 55,)),
                                    SizedBox(height: 5),
                                    Text('Pinkcity Runners', style: CustomTextStyles.semiBold(fontSize: 15),),

                                  ],
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('All clubs', style: CustomTextStyles.regular(textColor: AppColor.bgRed),)
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }


  Widget buildBadgeGrid(List<Map<String, String>> badges) {
    List<Widget> rows = [];

    for (int i = 0; i < badges.length; i += 3) {
      final rowItems = badges.skip(i).take(3).toList();

      rows.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // ✅ background per row
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowItems.map((badge) {
              return Column(
                children: [
                  Image.asset(
                    badge["image"]!,
                    height: 75, width: 70,
                  ),
                  SizedBox(height: 8),
                  Text(
                    badge["title"]!,
                    style: CustomTextStyles.semiBold(fontSize: 12),
                  ),

                  if (badge["subTitle"] != null && badge["subTitle"]!.isNotEmpty)
                    Text(
                      badge['subTitle']!,
                      style: CustomTextStyles.regular(fontSize: 12),
                    )
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}
