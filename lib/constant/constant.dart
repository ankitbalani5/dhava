
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/image/appImages.dart';
import '../resources/style/textStyle.dart';
import '../widgets/customButton.dart';
import 'errorDialog.dart';

class PrefKey {
  static var accessToken;
  static var refreshToken;
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

  static bool isJoinClub = false;

  static String getProfileScreenCount(){
    return '9';
  }

  static Widget likeImageWidget (){
    return Stack(
      children: [
        Container(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppImageOthers.userImg, height: 30,),
            ],
          ),
        ),

        Positioned(
            right: 25,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
        Positioned(
            right: 50,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
      ],
    );
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

  static String centimeterToFeet(String centimeter) {
    // Parse the centimeter input to a double
    double dCentimeter = double.tryParse(centimeter) ?? 0.0;

    // Calculate feet and inches
    int feetPart = (dCentimeter / 2.54 / 12).floor();
    int inchesPart = ((dCentimeter / 2.54) - (feetPart * 12)).ceil();

    // Return the formatted string
    return "$feetPart.$inchesPart";
  }


  void showCongratulationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🏆 Trophy Image
              Image.asset(
                AppImageOthers.trophy, // <-- Replace with your actual image path
                height: 180,
              ),

              const SizedBox(height: 20),

              // 🎉 Bold Title
              Text(
                  'Congratulation!',
                  style: CustomTextStyles.bold(fontSize: 26, textColor: Colors.black)
              ),

              const SizedBox(height: 10),

              // ✨ Subtitle
              Text(
                'You did a great job in the test!',
                style: CustomTextStyles.regular(textColor: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // 🔘 Continue Button
              CustomButton(
                text: 'Continue',
                callback: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SaveActivity()));
                },
              )
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.orangeAccent, // Button color
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pop(); // Close the dialog
              //     },
              //     child: const Text(
              //       'Continue',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
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