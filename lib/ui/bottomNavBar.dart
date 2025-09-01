
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/endurance.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/homeScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/news/newsScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:coherent_endurance/ui/defaultScreen/defaultScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/Constant.dart';
import '../resources/color/appColor.dart';
import '../resources/image/appImages.dart';
import '../resources/style/textStyle.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;
  SharedPreferences? sharedPreferences = Constant.sharedPreferences;

  final List<Widget> _baseScreens = [
    HomeScreen(),
    NewsScreen(),
    TrackingScreen()/*Endurance()*/,
    ClubScreen(),
    // DefaultScreen(isToolBar: false,)
    //TrackingScreen(),
  ];

  @override
  void initState() {
    _initializePreferences();
    super.initState();
  }

  _initializePreferences() {

    // _loadPage();
  }

  // _loadPage() {
  //   context.read<ProfileBloc>().add(ClearProfileDataEvent());
  //   context.read<ProfileBloc>().add(
  //     GetProfileEvent(
  //       context: context,
  //       securityCode: Constant.securityCode,
  //     ),
  //   );
  //
  //   //Injury
  //   context.read<InjuryBloc>().add(ClearInjuryEvent());
  //   context.read<InjuryBloc>().add(
  //     GetInjuryQuestionEvent(context: context, securityCode: Constant.securityCode),
  //   );
  //
  // }

  // _loadQuestionsPage(roleName) {
  //   var questionFor = QuestionKeys.getQuestionId(roleName);
  //   context.read<PreWorkoutQuestionBloc>().add(ClearWorkoutQuestionEvent());
  //   context.read<PreWorkoutQuestionBloc>().add(GetWorkoutQuestionEvent(context: context, securityCode: Constant.securityCode, questionFor : questionFor),);
  // }

  final List<Widget> _overlayStack = [];

  void addOverlay(Widget screen) {
    setState(() {
      _overlayStack.add(screen);
    });
  }

  void removeOverlay() {
    setState(() {
      if (_overlayStack.isNotEmpty) {
        _overlayStack.removeLast();
      }
    });
  }

  void clearOverlay() {
    setState(() {
      if (_overlayStack.isNotEmpty) {
        _overlayStack.clear();
      }
    });
  }

  int getOverlayCount() {
    return _overlayStack.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _baseScreens[_currentIndex], // Base screens
          ..._overlayStack, // Overlay screens
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 60,
        color: AppColor.backgroundGrey,
        //surfaceTintColor: Colors.black,
        child: Container(
          height: 60,
          decoration: BoxDecoration(color: AppColor.backgroundGrey),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              bottomNavItem(
                label: 'Home',
                index: 0,
                icon: AppImageSvg.home,
              ),
              bottomNavItem(
                label: 'News',
                index: 1,
                icon: AppImageSvg.news,
              ),
              bottomNavItem(
                label: 'Record',
                index: 2,
                icon: AppImageSvg.record,
              ),
              bottomNavItem(
                label: 'Club',
                index: 3,
                icon: AppImageSvg.club,
              ),
              // bottomNavItem(
              //   label: 'Profile',
              //   index: 4,
              //   icon: AppImageSvg.profile,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomNavItem({required String label, required int index, required String icon,}) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {

        if (index == 2) {
          // ✅ Navigate to TrackingScreen when clicking on Record tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrackingScreen()),
          );
        } else {
          // For other tabs, just change index
          setState(() {
            _currentIndex = index;
            _overlayStack.clear();
          });
        }
        // setState(() {
        //   _currentIndex = index;
        //   _overlayStack.clear();
        // });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        decoration:
        isSelected
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColor.primaryColor.withOpacity(0.2),
        )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 30, width: 30),
            if (isSelected) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: CustomTextStyles.semiBold(
                  fontSize: 14,
                  textColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
