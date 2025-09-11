import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/completeProfile/levelScreen.dart';
import 'package:coherent_endurance/ui/completeProfile/step5Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

class ChooseActivity extends StatefulWidget {
  const ChooseActivity({super.key});

  @override
  State<ChooseActivity> createState() => _ChooseActivityState();
}

class _ChooseActivityState extends State<ChooseActivity> {
  var isSelect = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What Types Of Activities \nDo You Like To Do?",
            style: CustomTextStyles.bold(fontSize: 22, textColor: Colors.black),),
          SizedBox(height: 20,),
          Text("Here's A Peek At What Coherent Has To Offer. When It's Time To Record An Activity, You Can Choose From Over 30 Sport Types."
            , style: CustomTextStyles.regular(fontSize: 14),
          ),
          SizedBox(height: 50,),
          GestureDetector(
            onTap: () {
              isSelect = 'run';
              setState(() {

              });
            },
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'run' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(
                  // tileColor: isSelect == 'run' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                  leading: SvgPicture.asset(AppImageSvg.run, color: Colors.black, height: 32,),
                  title: Text('Run', style: CustomTextStyles.semiBold(fontSize: 21),),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              isSelect = 'walk';
              setState(() {

              });
            },
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'walk' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(
                  // tileColor: isSelect == 'walk' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                  leading: SvgPicture.asset(AppImageSvg.walk, color: Colors.black, height: 32),
                  title: Text('Walk', style: CustomTextStyles.semiBold(fontSize: 21),),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              isSelect = 'cycle';
              setState(() {

              });
            },
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'cycle' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(
                  // tileColor: isSelect == 'cycle' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                  leading: SvgPicture.asset(AppImageSvg.cycle, color: Colors.black, height: 32,),
                  title: Text('Cycle', style: CustomTextStyles.semiBold(fontSize: 21),),
                ),
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CustomButton(
          text: 'Continue',
          // width: MediaQuery.of(context).size.width,
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {


            (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(Step5Screen());
            // (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(LevelScreen());
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()));
          },
        ),
      ),
    );
  }
}
