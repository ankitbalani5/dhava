
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'errorDialog.dart';


class Constant {

  static SharedPreferences? sharedPreferences;
  static bool isNavigation = false;

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

}