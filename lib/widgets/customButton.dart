
import 'package:flutter/material.dart';

import '../resources/color/appColor.dart';
import '../resources/style/textStyle.dart';

class CustomButton extends StatefulWidget {
  String text;
  VoidCallback callback;
  double? height;
  double fontSize;
  double? width;
  Widget? child;
  Color? color;
  Color? textColor;

  CustomButton(
      {super.key,
      required this.text,
      required this.callback,
      this.fontSize = 16,
      this.height,
      this.width,
      this.child,
      this.color = AppColor.bgRed,
      this.textColor = Colors.white});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.callback,
        child: Center(
          child: Container(
            height: widget.height ?? 50,
            width: widget.width ?? MediaQuery.of(context).size.width * .6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.color,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.child != null ? SizedBox(height: 20, width: 20, child: widget.child) : SizedBox(),
                SizedBox(width: widget.child != null ? 10 : 0,),
                Center(
                    child: Text(
                      widget.text,
                      style: CustomTextStyles.bold(textColor: widget.textColor ?? Colors.white,
                          fontSize:
                          widget.fontSize), // Choose the appropriate style
                    ))
              ],
            ),
          ),
        ));
  }
}
