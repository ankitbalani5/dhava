import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';

import 'chooseActivity.dart';
import 'createProfile.dart';
import 'levelScreen.dart';

class Step5Screen extends StatefulWidget {
  const Step5Screen({super.key});

  @override
  State<Step5Screen> createState() => _Step5ScreenState();
}

class _Step5ScreenState extends State<Step5Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImageOthers.step5Img,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,),
          Positioned(
            bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('Enjoy the company\nlike minded people', style: CustomTextStyles.boldWorkSens(fontSize: 31, textColor: Colors.white),),
                  SizedBox(height: 5,),
                  Text('150+ million active people on\nStrava are excited to move with you.', textAlign: TextAlign.center, style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.white),),
                  SizedBox(height: 40,),
                  CustomButton(text: "Let's go", callback: () {

                    (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(LevelScreen());
                  },)
                ],
              )
          )
        ],
      ),
    );
  }
}
