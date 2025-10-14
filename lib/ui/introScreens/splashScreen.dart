import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/constant/preferenceKey.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/authScreens/registerScreen.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/introScreens/sliderScreen.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottomNavigationScreens/home/feedDetails.dart';
import 'package:app_links/app_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SharedPreferences sharedPreferences;
  String deviceId = '';
  String securityCode = '';
  bool isLogin = false;
  int dotIndex = 0;
  Uri? deepLinkUri;

  @override
  void initState() {
    _initializePreferences();
    _checkDeepLink();
    super.initState();
  }

  Future<void> _initializePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool(PreferenceKey.isLogin) ?? false;


    getDeviceId();

    // fetchData();
  }

  Future<void> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        var androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceId = androidInfo.id;
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        var iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceId = iosInfo.identifierForVendor ?? '';
        });
      }
    } catch (e) {
      setState(() {
        deviceId = '';
      });
    }
    sharedPreferences.setString(PreferenceKey.deviceId, deviceId);
  }

  Future<void> _checkDeepLink() async {
    final appLinks = AppLinks();

    deepLinkUri = await appLinks.getInitialLink();

    appLinks.uriLinkStream.listen((uri) {
      deepLinkUri = uri;
    });

    Future.delayed(const Duration(seconds: 3), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    if (deepLinkUri != null &&
        deepLinkUri!.pathSegments.length >= 5 &&
        deepLinkUri!.pathSegments[0] == 'api' &&
        deepLinkUri!.pathSegments[1] == 'v1' &&
        deepLinkUri!.pathSegments[2] == 'activity' &&
        deepLinkUri!.pathSegments[3] == 'user-feed') {
      final activityId = deepLinkUri!.pathSegments[4];
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => FeedDetails(activityId: activityId),), (route) => false,);
    } else {
      // Normal flow after splash
      if (isLogin) {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => BottomNavBar(key: bottomNavKey),), (route) => false,);
      } else {
        var isFirstTime = sharedPreferences.getBool(PrefKey.isFirstTime);
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => isFirstTime == true ? SliderScreen() : RegisterScreen(),),
        );
      }
    }
  }

  fetchData() async {
    sharedPreferences.setString(PreferenceKey.deviceId, deviceId);

    Future.delayed(Duration(seconds: 3), () async {
      if (isLogin) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)),
              (route) => false,
        );
      }
      else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var isFirstTime = pref.getBool(PrefKey.isFirstTime);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> isFirstTime == true ? SliderScreen() : RegisterScreen()));
      }
    },);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.black,
        child: Center(
          child: Image.asset(
            AppImageOthers.splash, fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
