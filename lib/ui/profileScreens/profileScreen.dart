import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(AppImageOthers.user),
                Column(
                  children: [
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                height: 55,
                                width: 55,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: BackButtonWidget())),
        
                            SizedBox(width: 10,),
                            Text('Profile', style: CustomTextStyles.bold(fontSize: 18),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                  },
                                  child: SvgPicture.asset(AppImageSvg.setting)),
                              SizedBox(width: 10,),
                              SvgPicture.asset(AppImageSvg.option),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Positioned(
                  bottom: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text('Adam Smith', style: CustomTextStyles.bold(fontSize: 26 ),),
                        Text('Jaipur, India', style: CustomTextStyles.medium(fontSize: 17),),
                      ],
                    )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('500', style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.red),),
                        Text('Follower', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.red),),
                      ],
                    )
                  ],
                ),
                SizedBox(width: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('500', style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.red),),
                        Text('Following', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.red),),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      color: Colors.black, // background color
                      padding: const EdgeInsets.all(8),
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.black,
                          gridData: FlGridData(show: false), // grid lines hide
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()} km',
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
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
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
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
                    ListTile(
                      leading: SvgPicture.asset(AppImageSvg.activities),
                      title: Text('Activities', style: CustomTextStyles.semiBold(fontSize: 14 )),
                      subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                    ),
                    ListTile(
                      leading: SvgPicture.asset(AppImageSvg.statistics),
                      title: Text('Statistics', style: CustomTextStyles.semiBold(fontSize: 14 )),
                      subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10 , textColor: Colors.grey)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                    ),
                    ListTile(
                      leading: SvgPicture.asset(AppImageSvg.trophy),
                      title: Text('Trophy Case', style: CustomTextStyles.semiBold(fontSize: 14 )),
                      subtitle: Text('July 12, 2025', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey )),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
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
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(AppImageOthers.milestone, height: 75),
                                    SizedBox(height: 10,),
                                    Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(AppImageOthers.milestone, height: 75),
                                    SizedBox(height: 10,),
                                    Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(AppImageOthers.milestone, height: 75),
                                    SizedBox(height: 10,),
                                    Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('All Trophies', style: CustomTextStyles.regular(fontSize: 16),),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
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
                            color: Colors.white24,
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
                    )
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
