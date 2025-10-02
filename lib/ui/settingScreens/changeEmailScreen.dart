import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController emailController = TextEditingController();
  final String email = "anamanyadav0321@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Change email', style: CustomTextStyles.bold()),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email TextField (Read-only)
                TextField(
                  controller: TextEditingController(text: email),
                  readOnly: true, // User edit nahi kar paayega
                  decoration: InputDecoration(
                    labelText: "Current Email",
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: AppColor.lightGreyImageBackground,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color:  AppColor.lightGreyImageBackground,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color:  AppColor.lightGreyImageBackground,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey, // Focus hone par bhi underline nahi hoga
                        width: 1,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                )

              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                } else if (!EmailValidator.validate(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "New Email",
                // filled: true,
                // fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            Spacer(),
            CustomButton(text: "Next", callback: (){},color: AppColor.bgTextField,textColor: AppColor.textBackgroundGrey,)
          ],
        ),
      ),
    );
  }
}
