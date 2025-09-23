import 'package:coherent_endurance/data/createProfileData.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/dateOfBirthScreen.dart';
import 'package:flutter/material.dart';

import '../../resources/color/appColor.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  var _formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's Your Name?",
              style: CustomTextStyles.bold(fontSize: 22, textColor: Colors.black),),
            SizedBox(height: 12,),
            Text("We'll Use This For Performance Analysis. Filtering Leaderboards,"
                " And To Keep Younger Users Safe"
              , style: CustomTextStyles.regular(fontSize: 14),
            ),
            SizedBox(height: 65,),
            TextFormField(
              controller: firstNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'please enter first name';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Your First name",
                filled: true,
                fillColor: AppColor.bgTile,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),

                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),

                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),

                ),
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: lastNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'please enter last name';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Your Last name",
                filled: true,
                fillColor: AppColor.bgTile,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),

                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),

                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),

                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Your Profile is Public By Default.',
              style: CustomTextStyles.regular(textColor: Colors.grey, fontSize: 10),),


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
            if(_formKey.currentState!.validate()){
              CreateProfileData.firstName = firstNameController.text;
              CreateProfileData.lastName = lastNameController.text;

              FocusScope.of(context).unfocus();
              (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(DateOfBirthScreen());
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()));
          },
        ),
      ),
    );
  }
}
