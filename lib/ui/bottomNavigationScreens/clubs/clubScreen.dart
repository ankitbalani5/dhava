
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:flutter/material.dart';

import '../../../resources/image/appImages.dart';
import '../../../resources/style/textStyle.dart';
import '../../notification/notificationScreen.dart';
import '../../profileScreens/profileScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clubWidgets/active/activeWidget.dart';
import 'clubWidgets/challenges/challengesWidget.dart';
import 'clubWidgets/club/clubsWidget.dart';

class ClubScreen extends StatefulWidget {
  final String? initialTab;

  const ClubScreen({super.key, this.initialTab});

  @override
  State<ClubScreen> createState() => ClubScreenState();
}

class ClubScreenState extends State<ClubScreen> {
  String activeKey = 'Active';
  String challengesKey = 'Challenges';
  String clubsKey = 'Clubs';
  String tabStatus = 'Active';


  @override
  void initState() {
    super.initState();
    tabStatus = widget.initialTab ?? activeKey;
    loadJoinClub();
  }

  Future<void> loadJoinClub() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Constant.isJoinClub = prefs.getBool('isJoinClub') ?? false;
    });


  }


  Future<void> saveJoinClub(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isJoinClub', value);
    setState(() {
      Constant.isJoinClub = value;
    });

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
          tabStatus == clubsKey
              ? Expanded(
            child: clubsWidget(
              context: context,
              isJoinClub: Constant.isJoinClub,
              onJoinClub: (value) {
                saveJoinClub(value);
              },
            ),
          )
              : const SizedBox(),
          // tabStatus == clubsKey ?
          // Expanded(child: clubsWidget()) : SizedBox()
        ],
      ),
    );
  }
}




