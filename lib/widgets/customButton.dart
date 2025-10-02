
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatefulWidget {
 final String text;
 final VoidCallback callback;
 final double? height;
 final double fontSize;
 final double? width;
 final  Widget? child;
 final Color? color;
 final Color? textColor;

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
