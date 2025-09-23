import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/tabs/activitiesTab/activitiesTabScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/tabs/leaderboardTab/leaderboardTabScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/tabs/memberScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'editClubProfile.dart';

class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({super.key});

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImageOthers.clubDetailBanner),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 30,
                    child: Image.asset(AppImageOthers.backArrow),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 15,
                child: Row(
                  children: [
                    SizedBox(
                        height: 30,
                        child: Image.asset(AppImageOthers.notificationIcon)),
                     SizedBox(width: 8),
                    SizedBox(
                        height: 30,
                        child: Image.asset(AppImageOthers.shareIcon)),

                     SizedBox(width: 8),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditClubProfile()));
                      },
                      child: SizedBox(
                          height: 30,
                          child: Image.asset(AppImageOthers.editIcon)),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  child: Image.asset(AppImageOthers.clubDP),
                ),
              ),
            ],
          ),

           SizedBox(height: 20),
          Text(
            "We Runners Club",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
           SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppImageSvg.run, color: Colors.black54),
                   SizedBox(width: 5),
                   Text("Running",
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      height: 20,
                      child: Image.asset(AppImageOthers.memberIcon,
                          color: Colors.black54)),
                    SizedBox(width: 5),
                    Text("570 Members",
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      height: 20,
                      child: Image.asset(AppImageOthers.earthIcon,
                          color: Colors.black54)),
                    SizedBox(width: 5),
                    Text("Public",
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ],
          ),
            SizedBox(height: 20),
          if (!Constant.isJoinClub)
            Center(
              child: SizedBox(
                width: 150,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bgRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // join club action
                  },
                  child: Text(
                    "Join Club",
                    style: CustomTextStyles.semiBold(
                        fontSize: 14, textColor: Colors.white),
                  ),
                ),
              ),
            ),

           SizedBox(height: 5),
          Expanded(
            child: Container(
              color: Color(0xFFF2F2F0),
              child:  TabBarWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarWidget extends StatefulWidget {
    TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  late TabController controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {
        _selectedIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TabBar(
            controller: controller,
            labelColor: AppColor.bgRed,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 12,
                        child: Image.asset(
                          AppImageOthers.overviewIcon,
                          color: _selectedIndex == 0
                              ? AppColor.bgRed
                              : Colors.black54,
                        )),
                      SizedBox(width: 3),
                      Text("Overview", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 12,
                        child: Image.asset(
                          AppImageOthers.leaderIcon,
                          color: _selectedIndex == 1
                              ? AppColor.bgRed
                              : Colors.black54,
                        )),
                     SizedBox(width: 3),
                     Text("Leaderboard", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 12,
                        child: Image.asset(
                          AppImageOthers.activitiesIcon,
                          color: _selectedIndex == 2
                              ? AppColor.bgRed
                              : Colors.black54,
                        )),
                     SizedBox(width: 3),
                     Text("Activities", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,

              children: [
                _overviewTab(),
              LeaderboardTabScreen(),
                ActivitiesTabScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewTab() {
    return SingleChildScrollView(
      padding:  EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text("About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           SizedBox(height: 8),
           Text(
            "We Runners: Our vision is to bring as many runners as we can "
                "to connect with We Runners and expand our running club.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
           SizedBox(height: 20),

           Text("Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           SizedBox(height: 12),

          memberTile("We Runners Club", "OWNER",context),
          memberTile("Sandeep Yadav", "ADMIN",context),
          memberTile("Mohan Kumar", "",context),

           SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Text("View all members",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.bgRed,
                    fontWeight: FontWeight.bold)),
          ),
           SizedBox(height: 30),

          if (Constant.isJoinClub==true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Actions",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                 SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bgRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:  EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {

                      },
                      child: Text("Leave Club",
                          style: CustomTextStyles.semiBold(
                              fontSize: 14, textColor: Colors.white)),
                    ),
                  ),
                ),
                 SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:  EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {

                      },
                      child: Text("Report Club",
                          style: CustomTextStyles.semiBold(
                              fontSize: 14, textColor: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget memberTile(String name, String role,BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MemberScreen()));
    },
    child: ListTile(
      leading:  CircleAvatar(
        backgroundImage: AssetImage(AppImageOthers.defaultUserImg),
      ),
      title: Text(name,
          style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle:  Text("Jaipur, Rajasthan"),
      trailing: role.isNotEmpty
          ? Text(role,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.bgRed))
          : null,
    ),
  );
}
