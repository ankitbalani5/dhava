import 'package:coherent_endurance/bloc/loginBloc/login_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/repository/socialAuth.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/authScreens/sendCode.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  final SocialAuth _authService = SocialAuth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Log in to  ",
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset('assets/image/others/logoDhava.png', height: 25,)
                  ],
                ),
                const SizedBox(height: 30),

                // Google Register Button

                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) async {
                    if(state is GoogleLoading){
                      Constant.loadingDialog(context);
                    }
                    if(state is GoogleSuccess){
                      Constant.closeLoadingDialog(context);
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.setBool(PrefKey.isLogin, true);
                      print('isLogin::::::::::${pref.getBool(PrefKey.isLogin)}');
                      // pref.setString(PrefKey.accessToken, state.loginModel.data!.accessToken.toString());
                      // pref.setString(PrefKey.refreshToken, state.loginModel.data!.refreshToken.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BottomNavBar(key: bottomNavKey,)),);
                    }
                    if(state is GoogleError){
                      Constant.closeLoadingDialog(context);
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () async {
                        context.read<LoginBloc>().add(GoogleLoginEvent('', 'android',context));
                        // User? user = await _authService.signInWithGoogle(context);
                        // if (user != null) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (_) => BottomNavBar(key: bottomNavKey,)),
                        //   );
                        // }
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset(AppImageOthers.google, height: 24),
                            SizedBox(width: 10,),
                            Text("Continue With Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                // Facebook Register Button
                // Container(
                //   height: 56,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(6)
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(AppImageOthers.facebook, height: 24),
                //       SizedBox(width: 10,),
                //       Text("Continue With Facebook", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                //     ],
                //   ),
                // ),
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
                TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!EmailValidator.validate(value)) {
                      return "Enter a valid email";
                    }
                    return null; // ✅ valid case
                  },
                  decoration: InputDecoration(
                    hintText: "Email",

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
                      if(_formKey.currentState!.validate())
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SendCode(email: emailController.text)));
                    },
                ),

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
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google sign-in cancelled");
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;
      print("Google Access Token: $accessToken");
      print("Google ID Token: $idToken");

      Fluttertoast.showToast(msg: "Google sign-in successful");

    } catch (e) {
      Fluttertoast.showToast(msg: "Google sign-in failed: $e");
    }
  }

}
