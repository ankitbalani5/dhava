
import 'package:coherent_endurance/bloc/activityBloc/activity_bloc.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/endurance.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/homeScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/news/newsScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tipsScreen.dart';
import 'package:coherent_endurance/ui/defaultScreen/defaultScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import '../resources/color/appColor.dart';
import '../resources/image/appImages.dart';
import '../resources/style/textStyle.dart';
final GlobalKey<_BottomNavBarState> bottomNavKey = GlobalKey<_BottomNavBarState>();
class BottomNavBar extends StatefulWidget {
  int i ;
  BottomNavBar({this.i = 0, super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;
  SharedPreferences? sharedPreferences = Constant.sharedPreferences;
  String? _clubInitialTab;

  List<Widget> get _baseScreens => [
    HomeScreen(),
    NewsScreen(),
    Endurance(),
    TipScreen(),
    ClubScreen(initialTab: _clubInitialTab),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.i;
    _initializePreferences();

    context.read<ProfileBloc>().profileModel = null;
    context.read<ProfileBloc>().add(GetProfileEvent(context, ''));
    context.read<ProfileBloc>().add(CategoryEvent(context));
  }

  void openClubChallenges() {
    setState(() {
      _clubInitialTab = "Challenges";
      _currentIndex = 4;
      _overlayStack.clear();
    });
  }


  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
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
  int currentTap = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // agar koi overlay open hai → close karo
        if (_overlayStack.isNotEmpty) {
          setState(() {
            _overlayStack.removeLast();
          });
          return false;
        }

        // agar current tab Endurance hai → wapas Home tab
        if (_currentIndex == 2) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }

        // agar current tab Home nahi hai → Home tab pe le jao
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }


        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Press back again to exit")),
          );
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _baseScreens[_currentIndex], // Base screens
            ..._overlayStack, // Overlay screens
          ],
        ),

        bottomNavigationBar: Container(
          // elevation: 10,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey))
          ),
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 60,
            color: Colors.white,
            // color: AppColor.backgroundGrey,
            //surfaceTintColor: Colors.black,
            child: Container(
              height: 60,
              // decoration: BoxDecoration(
              //     border: Border(top: BorderSide(color: Colors.grey))
              // ),
              // decoration: BoxDecoration(color: AppColor.backgroundGrey),
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
                    label: 'Tips',
                    index: 3,
                    icon: AppImageSvg.tips,
                  ),
                  bottomNavItem(
                    label: 'Club',
                    index: 4,
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
        ),
      ),
    );
  }

  Widget bottomNavItem({required String label, required int index, required String icon,}) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        if (index != 4) {
          _clubInitialTab = null;
        } else {
          _clubInitialTab = null;
        }
        // if (index == 2) {
        //   // ✅ Navigate to TrackingScreen when clicking on Record tab
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => TrackingScreen()),
        //   );
        // } else {
          // For other tabs, just change index
          setState(() {
            _currentIndex = index;
            _overlayStack.clear();
          });
        // }
        // setState(() {
        //   _currentIndex = index;
        //   _overlayStack.clear();
        // });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        // decoration:
        // isSelected
        //     ? BoxDecoration(
        //   borderRadius: BorderRadius.circular(30),
        //   color: AppColor.primaryColor.withOpacity(0.2),
        // )
        //     : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(icon, height: 23, width: 23, color: isSelected ? AppColor.bgRed : Colors.black,),
                  Text(
                    label,
                    style: CustomTextStyles.semiBold(
                      fontSize: 8,
                      textColor: isSelected ? AppColor.bgRed : Colors.black,
                    ),
                  ),
              ],
            ),
            // if (isSelected) ...[
            //   const SizedBox(width: 5),
            //   Text(
            //     label,
            //     style: CustomTextStyles.semiBold(
            //       fontSize: 14,
            //       textColor: Colors.white,
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
