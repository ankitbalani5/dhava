import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/color/appColor.dart';
import '../../widgets/customButton.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Password",
              style: CustomTextStyles.bold(fontSize: 28, textColor: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              "Your New Password Must Be Different Previously Used",
              style: CustomTextStyles.regular(fontSize: 16),
            ),
            const SizedBox(height: 90),

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
            const SizedBox(height: 15),
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
            const SizedBox(height: 30),

            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     minimumSize: const Size(double.infinity, 50),
            //   ),
            //   child: const Text("Verify Number",
            //       style: TextStyle(color: Colors.white)),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child:
        CustomButton(
          text: 'Save',
          // width: MediaQuery.of(context).size.width,
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
          },),
      ),
    );
  }
}
