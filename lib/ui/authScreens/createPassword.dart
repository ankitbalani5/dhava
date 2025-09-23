import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';


class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Password",
              style: CustomTextStyles.bold(fontSize: 28, textColor: Colors.black),
            ),
             SizedBox(height: 5),
            Text(
              "Your New Password Must Be Different Previously Used",
              style: CustomTextStyles.regular(fontSize: 16),
            ),
             SizedBox(height: 90),

            Text('New Password', style: CustomTextStyles.medium(fontSize: 14),),
            SizedBox(height: 5,),
            TextField(
              decoration: InputDecoration(
                hintText: "**********",
                filled: true,
                fillColor: Colors.grey[200],

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
              obscureText: true,
            ),
             SizedBox(height: 15),
            Text('Confirm Password', style: CustomTextStyles.medium(fontSize: 14),),
            SizedBox(height: 5,),
            TextField(
              decoration: InputDecoration(
                hintText: "**********",
                filled: true,
                fillColor: Colors.grey[200],

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
              obscureText: true,
            ),
             SizedBox(height: 30),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child:
        CustomButton(
          text: 'Save',
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
          },),
      ),
    );
  }
}
