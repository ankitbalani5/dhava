import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/ui/authScreens/forgotPassword.dart';
import 'package:coherent_endurance/ui/authScreens/otpScreen.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool isVisible = false;
  bool rememberMe = false;

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
              "Enter your password",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Log In With ", style: CustomTextStyles.regular(fontSize: 16, textColor: Colors.black),),
                Text("NamanYadav0321@gmail.com", style: CustomTextStyles.bold(fontSize: 16, textColor: Colors.black),),
              ],
            ),
            const SizedBox(height: 60),

            // Password Input
            TextField(
              obscureText: !isVisible,
              decoration: InputDecoration(
                hintText: "Enter Your Password",
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                suffixIcon: IconButton(
                  icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => isVisible = !isVisible),
                ),

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
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: rememberMe,
                      checkColor: Colors.grey, // ✅ Tick का रंग ग्रे होगा
                      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white; // ✅ Active होने पर background white रहेगा
                        }
                        return Colors.transparent; // ✅ Inactive होने पर transparent रहेगा
                      }),
                      side: MaterialStateBorderSide.resolveWith((states) {
                        return const BorderSide(
                          color: Colors.grey, // ✅ Border हमेशा grey रहेगा
                          width: 1.5,
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    )


                  ),
                  Text("Remember Me", style: CustomTextStyles.regular(fontSize: 11, textColor: Colors.grey),)
                ]),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                  },
                  child: Text("Forgot Password?", style: CustomTextStyles.regular(fontSize: 11, textColor: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 20),


            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     minimumSize: const Size(double.infinity, 50),
            //   ),
            //   child: const Text("Log In", style: TextStyle(color: Colors.white)),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: CustomButton(
          text: 'Log In',
          // width: MediaQuery.of(context).size.width,
          color: AppColor.bgTile,
          textColor: Colors.black,
          callback: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey), ), (route) => false,);
          },),
      ),
    );
  }
}
