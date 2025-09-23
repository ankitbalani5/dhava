
import 'package:coherent_endurance/bloc/loginBloc/login_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/constant/preferenceKey.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validate_phone_number/country_picker.dart';
import 'package:validate_phone_number/validation.dart';
import 'otpVerificationScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences? sharedPreferences = Constant.sharedPreferences;
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String deviceId = "";
  bool isPasswordVisible = false;


  @override
  void initState() {
    _loadPreferenceData();
    super.initState();
  }

  void _loadPreferenceData() {
    deviceId = sharedPreferences?.getString(PreferenceKey.deviceId) ?? '';


    setState(() {});
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Coherent\nEndurance',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bold(fontSize: 28, ).copyWith(
                      height: 0.9,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Enter Your Email To Register\nYour Account ',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bold(fontSize: 22),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Register Your Account To Track Your Fitness\n And Manage Your Progress ',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.smallRegular(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColor.textBackgroundGrey,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixStyle: TextStyle(
                      color: AppColor.textBackgroundGrey,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PickCountry(
                        onCountrySelected: (phoneCode, countryCode) {},
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: AppColor.textBackgroundGrey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: AppColor.textBackgroundGrey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: AppColor.textBackgroundGrey)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:  BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:  BorderSide(color: Colors.red)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!Validator.validatePhoneNumber(
                        value.toString(), 'IN')) {
                      return 'Invalid mobile number';
                    } else {
                      return null;
                    }
                  },
                ),

                SizedBox(height: 20),
                BlocConsumer<LoginBloc, LoginState>(

                  builder: (context, state) {
                    return CustomButton(
                      width: screenHeight * .30,
                      text: state is LoginLoading ? '' : 'Verify Number',
                      callback:
                          state is LoginLoading
                              ? () {}
                              : () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OtpVerificationScreen(),
                                        ),
                                            (route) => false,
                                      );
                              },
                      child:
                          state is LoginLoading
                              ? Center(
                                child: LoadingAnimationWidget.inkDrop(
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                              : null,
                    );
                  }, listener: (BuildContext context, LoginState state) {  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
