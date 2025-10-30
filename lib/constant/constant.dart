
import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/models/profileModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:coherent_endurance/ui/profileScreens/editProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/image/appImages.dart';
import '../resources/style/textStyle.dart';
import '../ui/bottomNavBar.dart';
import '../widgets/customButton.dart';
import '../widgets/loadingAnimation.dart';
import 'errorDialog.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class PrefKey {
  static String isLogin = 'isLogin';
  static String isFirstTime = 'isFirstTime';
  static String savedEmail = 'saved_email';
  static String savedPassword = 'saved_password';
  static String rememberMe = 'remember_me';
  static var accessToken = 'accessToken';
  static var refreshToken = 'refreshToken';
  static var fcmToken = 'fcmToken';
}

class Constant {

  static SharedPreferences? sharedPreferences;
  static bool isNavigation = false;
  static var token;
  static var firstName;
  static var lastName;
  static var email;
  static var image;
  static var fcmToken;
  static var access_token;
  static var refresh_token;
  static CategoryModel? getCategory;

  static bool isJoinClub = false;

  static String getProfileScreenCount(){
    return '9';
  }

  static Widget loadingAnimation(){
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: AppColor.bgRed,
        size: 20,
      ),
    );
  }


  static String formatPace(double paceInSec) {
    if (paceInSec.isInfinite || paceInSec.isNaN || paceInSec == 0) return "0:00";
    int min = (paceInSec / 60).floor();
    int sec = (paceInSec % 60).floor();
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  // static List<FlSpot> generatePaceSpots(String paceStr) {
  //   if (paceStr.isEmpty) return [];
  //
  //   // paceStr जैसे "21:54,6:12" को split करना
  //   final paceList = paceStr.split(',');
  //
  //   List<FlSpot> spots = [];
  //   for (int i = 0; i < paceList.length; i++) {
  //     final pace = paceList[i];
  //     final parts = pace.split(':');
  //     if (parts.length == 2) {
  //       final min = double.tryParse(parts[0]) ?? 0;
  //       final sec = double.tryParse(parts[1]) ?? 0;
  //       final totalSeconds = min * 60 + sec;
  //       // X-axis = km (1-based index), Y-axis = pace seconds
  //       spots.add(FlSpot(i.toDouble() + 1, totalSeconds));
  //     }
  //   }
  //   return spots;
  // }

  static List<FlSpot> generateElevationSpots(String elevationStr) {
    final parts = elevationStr.split(',');
    final List<FlSpot> spots = [];
    for (int i = 0; i < parts.length; i++) {
      final y = double.tryParse(parts[i]) ?? 0.0;
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  static double getMaxElevation(String elevationStr) {
    final parts = elevationStr.split(',');
    double maxVal = 0;
    for (var val in parts) {
      final y = double.tryParse(val) ?? 0;
      if (y > maxVal) maxVal = y;
    }
    return maxVal + 5; // थोड़ा margin
  }




  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    String result = "";
    if (hours > 0) result += "${hours}h ";
    if (minutes > 0) result += "${minutes}m ";
    if (secs > 0 || result.isEmpty) result += "${secs}s";

    return result.trim();
  }

  static double calculateProgress(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();

    if (now.isBefore(startDate)) return 0.0;

    if (now.isAfter(endDate)) return 1.0;

    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsed = now.difference(startDate).inSeconds;
    print('totalDuration:::$totalDuration');
    print('elapsed:::$elapsed');

    double progress = elapsed / totalDuration;

    return progress.clamp(0.0, 1.0);
  }

  static Map<String, dynamic> calculateChallengeDuration(String? startDateStr, String? endDateStr) {
    try {
      if (startDateStr == null || endDateStr == null) {
        return {'weeks': 0, 'daysLeft': 0};
      }

      final startDate = DateTime.parse(startDateStr);
      final endDate = DateTime.parse(endDateStr);
      final now = DateTime.now();

      // Weeks between start and end
      final totalDays = endDate.difference(startDate).inDays;
      final weeks = (totalDays / 7).ceil();

      // Days remaining from today
      final remainingDays = endDate.difference(now).inDays;

      return {
        'weeks': weeks > 0 ? weeks : 0,
        'daysLeft': remainingDays > 0 ? remainingDays : 0,
      };
    } catch (e) {
      return {'weeks': 0, 'daysLeft': 0};
    }
  }

  static loadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              content: Center(
                child: LoadingAnimation(),
              )),
        ));
  }

  static closeLoadingDialog(BuildContext context) {
    return Navigator.pop(context);
  }

  static showErrorDialog(BuildContext context, bool isSuccess, String message,  VoidCallback callback) {
    Future.microtask(() => showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return ErrorDialog(message: message, isSuccess: isSuccess, callback: callback,);
      },
    ));
  }

  static String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split(" ").map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(" ");
  }


  static Widget showCompleteProfileDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.redAccent, width: 1), // border line
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImageOthers.completeProfileDialogIcon, height: 50, width: 50,),
                SizedBox(height: 15,),
                // Title
                Text(
                  "Need to complete your profile before proceeds",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bold(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  "To complete the sign up process, please Choose the language",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),
                ),
                const SizedBox(height: 25),

                // Complete Profile Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) => CreateProfile()), (route) => false,);
                  },
                  child: Text(
                    "Complete Profile",
                    style: CustomTextStyles.semiBold(fontSize: 16, textColor: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                // Skip For Now Button
                CustomButton(
                  color: Colors.white,
                  textColor: AppColor.bgRed,
                  fontSize: 16,
                  text: 'Skip For Now',
                  callback: () {
                    if (Navigator.canPop(context)) {
                      Constant.closeLoadingDialog(context); // close loading if open

                    }
                  },

                )

              ],
            ),
          ),

          // Top circular icon (overlapping)
          // Positioned(
          //   top: -40,
          //   child: CircleAvatar(
          //     radius: 30,
          //     backgroundColor: Colors.white,
          //     child: Container(
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         gradient: LinearGradient(
          //           colors: [Colors.redAccent, Colors.orangeAccent],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //       ),
          //       child: const CircleAvatar(
          //         radius: 28,
          //         backgroundColor: Colors.transparent,
          //         child: Icon(Icons.directions_run, color: Colors.white, size: 28),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }



  static String centimeterToFeet(String centimeter) {
    // Parse the centimeter input to a double
    double dCentimeter = double.tryParse(centimeter) ?? 0.0;

    // Calculate feet and inches
    int feetPart = (dCentimeter / 2.54 / 12).floor();
    int inchesPart = ((dCentimeter / 2.54) - (feetPart * 12)).ceil();

    // Return the formatted string
    return "$feetPart.$inchesPart";
  }




  static String formatDob(String dobString) {
    try {
      DateTime dob = DateTime.parse(dobString); // 2000-04-04T00:00:00
      return DateFormat('dd/MM/yyyy').format(dob); // 04/04/2000
    } catch (e) {
      return dobString; // fallback
    }
  }


  static Widget expandTimeWidget(){
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Time', style: CustomTextStyles.semiBold()),
          Text('00:00:00', style: CustomTextStyles.bold(fontSize: 80),),
          Divider(),
          Text('AVG PACE', style: CustomTextStyles.semiBold()),
          Text('0:00', style: CustomTextStyles.bold(fontSize: 150),),
          Text('/KM', style: CustomTextStyles.semiBold()),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 50,
                    color: Colors.blue,
                  ),
                  Text('0:00', style: CustomTextStyles.semiBold()),
                ],
              ),

              SizedBox(
                height: 200,
                child: Expanded(
                  child: VerticalDivider(
                    thickness: 1,
                    color: Colors.grey,
                    // width: 20,
                  ),
                ),
              ),
              Column(
                children: [
                  Text('DISTANCE', style: CustomTextStyles.semiBold()),
                  Text('0:00', style: CustomTextStyles.bold(fontSize: 70),),
                  Text('KILOMETERS', style: CustomTextStyles.semiBold()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}