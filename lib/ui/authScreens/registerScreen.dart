import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/authScreens/passwordScreen.dart';
import 'package:coherent_endurance/ui/authScreens/sendCode.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Log in to Coherent\nEndurance",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
        
              // Google Register Button

              Container(
                height: 56,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(AppImageOthers.facebook, height: 24),
                    Image.asset(AppImageOthers.google, height: 24),
                    SizedBox(width: 10,),
                    Text("Continue With Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // ElevatedButton.icon(
              //   onPressed: () {},
              //   icon: Image.asset(AppImageOthers.google, height: 24),
              //   label: const Text("Continue With Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black,
              //     minimumSize: const Size(double.infinity, 50),
              //     side: const BorderSide(color: Colors.grey),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
        
              // Facebook Register Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImageOthers.facebook, height: 24),
                    SizedBox(width: 10,),
                    Text("Continue With Facebook", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 1,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(child: Text("Or", style: TextStyle(color: Colors.grey),)),
                  ),
                  Expanded(child: Divider(color: Colors.grey,)),
                ],
              ),
              const SizedBox(height: 20),
        
              // Email Input
              TextField(
                decoration: InputDecoration(
                  hintText: "Email",
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
              const SizedBox(height: 20),
        
              CustomButton(
                text: 'Continue',
                // width: MediaQuery.of(context).size.width,
                color: AppColor.bgTile,
                textColor: Colors.black,
                callback: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SendCode()));
              },),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.black,
              //     minimumSize: const Size(double.infinity, 50),
              //   ),
              //   child: const Text("Continue", style: TextStyle(color: Colors.white)),
              // ),
              const SizedBox(height: 15),
        
              Center(
                child: SizedBox(
                  width: 280,
                  child: Text.rich(
                    TextSpan(
                      text: "By Continuing, You Are Agreeing To Our ",
                      style: GoogleFonts.inter(fontSize: 12),
                      children: [
                        TextSpan(
                          text: "Terms Of Service",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                              // color: Colors.red[600], fontWeight: FontWeight.bold
                          ),
                        ),
                        const TextSpan(text: " And "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                              // color: Colors.red[600], fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
