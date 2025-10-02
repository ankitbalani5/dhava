import 'package:coherent_endurance/data/createProfileData.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/reasonScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'createProfile.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  var isSelect = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Where Are You In Your \nFitness Journey?",
            style: CustomTextStyles.bold(fontSize: 22, textColor: Colors.black),),
          SizedBox(height: 10,),
          Text("People Of All Experience Levels Use Coherent, From Total Beginners To Professional Athletes."
            , style: CustomTextStyles.regular(fontSize: 14),
          ),
          SizedBox(height: 50,),
          GestureDetector(
            onTap: () {
              isSelect = 'beginner';
              setState(() {

              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'beginner' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: ListTile(
                // tileColor: isSelect == 'beginner' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                title: Text('Beginner', style: CustomTextStyles.bold(fontSize: 14),),
                subtitle: Text("I'm new to fitness or getting back into it.",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              isSelect = 'intermediate';
              setState(() {

              });
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'intermediate' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(

                  title: Text('Intermediate', style: CustomTextStyles.bold(fontSize: 14),),
                  subtitle: Text("I can do easy-moderate activities.",
                      style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              isSelect = 'advanced';
              setState(() {

              });
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'advanced' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(
                  // tileColor: isSelect == 'advanced' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                  title: Text('Advanced', style: CustomTextStyles.bold(fontSize: 14),),
                  subtitle: Text("I like to push myself with difficult activities.",
                      style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              isSelect = 'pro';
              setState(() {

              });
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelect == 'pro' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
              ),
              child: Center(
                child: ListTile(
                  // tileColor: isSelect == 'pro' ? AppColor.bgRed.withOpacity(.5) : AppColor.bgTextField,
                  title: Text('Pro', style: CustomTextStyles.bold(fontSize: 14),),
                  subtitle: Text("I'm a professional athlete.",
                      style: TextStyle(fontSize: 14)),
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

            if(isSelect.isNotEmpty){
              CreateProfileData.fitnessLevel = isSelect;
              print(CreateProfileData.fitnessLevel);
              (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(ReasonScreen());
            }else{
              Fluttertoast.showToast(msg: 'please select your fitness level');
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()));
          },
        ),
      ),
    );
  }
}
