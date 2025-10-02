import 'dart:ui';
import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle semiBold({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'InterSemiBold',
      fontWeight: FontWeight.w600,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static TextStyle bold({Color textColor = Colors.black, double fontSize = 18}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'InterBold',
      fontWeight: FontWeight.bold,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static TextStyle boldWorkSens({Color textColor = Colors.black, double fontSize = 18}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'WorkSansBold',
      fontWeight: FontWeight.bold,
      textBaseline: TextBaseline.alphabetic,
    );
  }


  static TextStyle smallRegular({Color textColor = Colors.black, double fontSize = 12}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'InterRegular',
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static TextStyle regular({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'InterRegular',
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  static TextStyle medium({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontFamily: 'InterMedium',
      fontWeight: FontWeight.w500,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}
