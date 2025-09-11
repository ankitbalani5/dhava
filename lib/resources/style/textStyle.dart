import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextStyles {
  // Function to return the SemiBold TextStyle
  static TextStyle semiBold({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_10dp
      color: textColor, // Dynamically set text color
      fontFamily: 'InterSemiBold', // Corresponds to @font/work_sans_semi_bold
      fontWeight: FontWeight.w600, // Semi-bold equivalent
      textBaseline: TextBaseline.alphabetic,
    );
  }

  // Function to return the Bold TextStyle
  static TextStyle bold({Color textColor = Colors.black, double fontSize = 18}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_10dp
      color: textColor, // Dynamically set text color
      fontFamily: 'InterBold', // Corresponds to @font/work_sans_bold
      fontWeight: FontWeight.bold,
      textBaseline: TextBaseline.alphabetic,
    );
  }
  // Function to return the Bold TextStyle
  static TextStyle boldWorkSens({Color textColor = Colors.black, double fontSize = 18}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_10dp
      color: textColor, // Dynamically set text color
      fontFamily: 'WorkSansBold', // Corresponds to @font/work_sans_bold
      fontWeight: FontWeight.bold,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  // Function to return the Regular TextStyle
  static TextStyle smallRegular({Color textColor = Colors.black, double fontSize = 12}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_8dp
      color: textColor, // Dynamically set text color
      fontFamily: 'InterRegular', // Corresponds to @font/work_sans_semi_bold
      fontWeight: FontWeight.w400, // Semi-bold equivalent
      textBaseline: TextBaseline.alphabetic,
    );
  }

  // Function to return the Regular TextStyle
  static TextStyle regular({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_8dp
      color: textColor, // Dynamically set text color
      fontFamily: 'InterRegular', // Corresponds to @font/work_sans_semi_bold
      fontWeight: FontWeight.w400, // Semi-bold equivalent
      textBaseline: TextBaseline.alphabetic,
    );
  }

  // Function to return the Medium TextStyle
  static TextStyle medium({Color textColor = Colors.black, double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize, // Corresponds to @dimen/custom_size_10dp
      color: textColor, // Dynamically set text color
      fontFamily: 'InterMedium', // Corresponds to @font/work_sans_regular
      fontWeight: FontWeight.w500, // Medium equivalent
      textBaseline: TextBaseline.alphabetic,
    );
  }
}
