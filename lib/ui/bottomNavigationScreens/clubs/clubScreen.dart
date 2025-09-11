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
  final String? initialTab; // ✅ नया parameter

  const ClubScreen({super.key, this.initialTab});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  String activeKey = 'active';
  String challengesKey = 'challenges';
  String clubsKey = 'clubs';
  String tabStatus = 'active';


  @override
  void initState() {
    super.initState();
    // ✅ अगर initialTab आया है तो वही सेट होगा, वरना active रहेगा
    tabStatus = widget.initialTab ?? activeKey;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                    borderRadius: BorderRadius.circular(8),
                    color: tabStatus == activeKey ? AppColor.bgRed : AppColor.bgTile
                  ),
                  child: Center(child: Text(activeKey, style: CustomTextStyles.medium(fontSize: 16, textColor: tabStatus == activeKey ? Colors.white : Colors.black),)),
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
                    borderRadius: BorderRadius.circular(8),
                    color: tabStatus == challengesKey ? AppColor.bgRed : AppColor.bgTile
                  ),
                  child: Center(child: Text(challengesKey, style: CustomTextStyles.medium(fontSize: 16, textColor: tabStatus == challengesKey ? Colors.white : Colors.black),)),
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
                    borderRadius: BorderRadius.circular(8),
                    color: tabStatus == clubsKey ? AppColor.bgRed : AppColor.bgTile
                  ),
                  child: Center(child: Text(clubsKey, style: CustomTextStyles.medium(fontSize: 16, textColor: tabStatus == clubsKey ? Colors.white : Colors.black),)),
                ),
              ),
            ],
          ),
          tabStatus == activeKey ?
          Expanded(child: ActiveWidget()) : SizedBox(),
          tabStatus == challengesKey ?
          Expanded(child: challengesWidget()) : SizedBox(),
          tabStatus == clubsKey ?
          Expanded(child: clubsWidget()) : SizedBox()
        ],
      ),
    );
  }
}




