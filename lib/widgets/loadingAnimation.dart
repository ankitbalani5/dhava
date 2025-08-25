
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constant/constant.dart';
import '../resources/color/appColor.dart';

class LoadingAnimation extends StatefulWidget {
  Color color;
  LoadingAnimation({this.color = AppColor.primaryColor, super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: widget.color,
        size: 20,
      ),);
  }
}
