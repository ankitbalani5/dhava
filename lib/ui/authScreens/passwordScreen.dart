import 'package:coherent_endurance/bloc/loginBloc/login_bloc.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/forgotPassword.dart';
import 'package:coherent_endurance/ui/authScreens/otpScreen.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordScreen extends StatefulWidget {
 final String email;
  PasswordScreen({required this.email, super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool isVisible = false;
  bool rememberMe = false;
  var _formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadSavedCredentials();
  }


  void fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var isRememberMe = pref.getBool(PrefKey.rememberMe);
    if(isRememberMe != null && isRememberMe == true){
      passwordController.text = pref.getString(PrefKey.savedPassword)!;
    }
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isRemember = prefs.getBool(PrefKey.rememberMe) ?? false;

    if (isRemember) {
      setState(() {
        rememberMe = true;
        passwordController.text = prefs.getString(PrefKey.savedPassword) ?? '';

      });
    }
  }

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
        child: Form(
          key: _formKey,
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
                  Text(widget.email, style: CustomTextStyles.bold(fontSize: 16, textColor: Colors.black),),
                ],
              ),
              const SizedBox(height: 60),

              // Password Input
              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: !isVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  } else if (value.length < 8) {
                    return 'Please length should not be less then 8'
                    ;
                  } else {
                    return null;
                  }
                },
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
                        checkColor: Colors.grey,
                        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return Colors.transparent;
                        }),
                        side: MaterialStateBorderSide.resolveWith((states) {
                          return const BorderSide(
                            color: Colors.grey,
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

            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<LoginBloc, LoginState>(
  listener: (context, state) async {
    if (state is LoginSuccess) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(PrefKey.isLogin, true);
      print('isLogin::::::::::${pref.getBool(PrefKey.isLogin)}');
      pref.setString(PrefKey.accessToken, state.loginModel.data!.accessToken.toString());
      pref.setString(PrefKey.refreshToken, state.loginModel.data!.refreshToken.toString());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey), ), (route) => false,);

    }
    if (state is LoginError) {
      Fluttertoast.showToast(msg: state.error);
    }
  },
  builder: (context, state) {
    return BottomAppBar(
        color: Colors.transparent,
        child: CustomButton(
          text: state is LoginLoading ? '' : 'Log In',
          color: AppColor.bgTile,
          textColor: Colors.black,
          callback:
          state is LoginLoading
              ? () {}
              : () async {
            if(_formKey.currentState!.validate()){

              if (rememberMe) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(PrefKey.savedEmail, widget.email);
                await prefs.setString(PrefKey.savedPassword, passwordController.text);
                await prefs.setBool(PrefKey.rememberMe, true);
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove(PrefKey.savedEmail);
                await prefs.remove(PrefKey.savedPassword);
                await prefs.setBool(PrefKey.rememberMe, false);
              }
            context.read<LoginBloc>().add(UserLoginEvent(context: context, email: widget.email, password: passwordController.text , fcmToken: '', deviceId: '', deviceType: 'mobile'));
            }

          },
          child:
          state is LoginLoading
              ? Center(
            child: LoadingAnimationWidget.inkDrop(
              color: AppColor.bgRed,
              size: 20,
            ),
          )
              : null,
        ),
      );
  },
),
    );
  }
}
