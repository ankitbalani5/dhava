import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/material.dart';

import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import '../bottomNavBar.dart';

class Step9Screen extends StatefulWidget {
  const Step9Screen({super.key});

  @override
  State<Step9Screen> createState() => _Step9ScreenState();
}

class _Step9ScreenState extends State<Step9Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImageOthers.step9Img,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,),
          Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('Welcome, Parul!', style: CustomTextStyles.boldWorkSens(fontSize: 31, textColor: Colors.white),),
                  SizedBox(height: 5,),
                  Text('150+ million active people on\nStrava are excited to move with you.', textAlign: TextAlign.center, style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.white),),
                  SizedBox(height: 40,),
                  CustomButton(text: "Let's go", callback: () {

                    // (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(LevelScreen());

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)), (route) => false,);
                  },)
                ],
              )
          )
        ],
      ),
    );
  }
}
