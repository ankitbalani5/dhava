import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:flutter/material.dart';

import '../../../resources/image/appImages.dart';
import '../../../resources/style/textStyle.dart';
import '../../notification/notificationScreen.dart';
import '../../profileScreens/profileScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'clubWidgets/activeWidget.dart';
import 'clubWidgets/challengesWidget.dart';
import 'clubWidgets/clubsWidget.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  String activeKey = 'active';
  String challengesKey = 'challenges';
  String clubsKey = 'clubs';
  String tabStatus = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Challenges', style: CustomTextStyles.bold(),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.notification,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    AppImageOthers.defaultImage,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  tabStatus = activeKey;
                  setState(() {

                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: tabStatus == activeKey ? AppColor.bgRed : Colors.white24
                  ),
                  child: Center(child: Text(activeKey, style: CustomTextStyles.medium(fontSize: 16),)),
                ),
              ),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  tabStatus = challengesKey;
                  setState(() {

                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: tabStatus == challengesKey ? AppColor.bgRed : Colors.white24
                  ),
                  child: Center(child: Text(challengesKey, style: CustomTextStyles.medium(fontSize: 16),)),
                ),
              ),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  tabStatus = clubsKey;
                  setState(() {

                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: tabStatus == clubsKey ? AppColor.bgRed : Colors.white24
                  ),
                  child: Center(child: Text(clubsKey, style: CustomTextStyles.medium(fontSize: 16),)),
                ),
              ),
            ],
          ),
          tabStatus == activeKey ?
          Expanded(child: activeWidget()) : SizedBox(),
          tabStatus == challengesKey ?
          Expanded(child: challengesWidget()) : SizedBox(),
          tabStatus == clubsKey ?
          Expanded(child: clubsWidget()) : SizedBox()
        ],
      ),
    );
  }
}




