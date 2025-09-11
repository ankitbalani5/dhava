import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:flutter/material.dart';

import '../../resources/color/appColor.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';
import 'findYourFriends.dart';

class ReasonScreen extends StatefulWidget {
  const ReasonScreen({super.key});

  @override
  State<ReasonScreen> createState() => _ReasonScreenState();
}

class _ReasonScreenState extends State<ReasonScreen> {
  var isSelect = '';
  List reasonData = [
    'Connect with other active people',
    'Train for an event or personal goal',
    'Build an exercise habit',
    'Maintain my health',
    'Explore new places',
    'Compete with others'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What Do You Plan To Use \nCoherent For?",
              style: CustomTextStyles.bold(fontSize: 22, textColor: Colors.black),),
            SizedBox(height: 10,),
            Text("Choose As Many That Resonate With You."
              , style: CustomTextStyles.regular(fontSize: 14),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[0];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[0] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[0] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[0],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[1];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[1] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[1] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[1],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[2];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[2] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[2] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[2],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[3];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[3] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[3] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[3],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[4];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[4] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[4] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[4],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                isSelect = reasonData[5];
                setState(() {
        
                });
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelect == reasonData[5] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                ),
                child: Center(
                  child: ListTile(
                    // tileColor: isSelect == reasonData[5] ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                    title: Text(reasonData[5],
                      style: CustomTextStyles.bold(fontSize: 14),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CustomButton(
          text: 'Continue',
          // width: MediaQuery.of(context).size.width,
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {

            // (context.findAncestorStateOfType<EditProfileScreenState>())?.addOverlay(DateOfBirthScreen());
            (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(FindYourFriends());
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar()), (route) => false,);
          },
        ),
      ),
    );
  }
}
