import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
 final Color backgroundColor;
 final Color arrowColor;
  BackButtonWidget({this.backgroundColor = Colors.transparent , this.arrowColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: backgroundColor),
      child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.arrow_back_ios, color: arrowColor),
          )),
    );
  }
}
