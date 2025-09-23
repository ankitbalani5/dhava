
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/authScreens/registerScreen.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/introScreens/sliderScreen.dart';
import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/preferenceKey.dart';

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

  @override
  void initState() {
    _initializePreferences();
    super.initState();
  }

  Future<void> _initializePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool(PreferenceKey.isLogin) ?? false;


    getDeviceId();

    fetchData();
  }

  Future<void> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        var androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceId = androidInfo.id; // Unique device ID on Android
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        var iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceId = iosInfo.identifierForVendor ?? ''; // Unique ID on iOS
        });
      }
    } catch (e) {
      setState(() {
        deviceId = '';
      });
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
