import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/otpScreen.dart';
import 'package:coherent_endurance/ui/authScreens/passwordScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';

class SendCode extends StatefulWidget {
  const SendCode({super.key});

  @override
  State<SendCode> createState() => _SendCodeState();
}

class _SendCodeState extends State<SendCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImageOthers.sendCode, fit: BoxFit.fill, width: MediaQuery.of(context).size.width,),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.width/3,
              child: CustomButton(
                width: 265,
                fontSize: 20,
                text: 'Email me a code',
                callback: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                },)
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.width/5,
              child: TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordScreen()));
              }, child: Text('Use Password Instead', style: CustomTextStyles.semiBold(fontSize: 20, textColor: AppColor.bgRed),))
          )
        ],
      ),
    );
  }
}
