
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validate_phone_number/country_picker.dart';
import 'package:validate_phone_number/validation.dart';

import '../../bloc/loginBloc/login_bloc.dart';
import '../../constant/Constant.dart';
import '../../constant/preferenceKey.dart';
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


    setState(() {}); // Ensure UI updates if needed after initialization
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SvgPicture.asset(AppImageSvg.logo2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        borderSide: const BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.red)),
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
                // TextFormField(
                //   readOnly: false,
                //   //textCapitalization: TextCapitalization.none,
                //   controller: emailController,
                //   keyboardType: TextInputType.emailAddress,
                //   style: CustomTextStyles.semiBold(),
                //   // Input text color
                //   decoration: InputDecoration(
                //     hintText: 'Email',
                //     hintStyle: CustomTextStyles.semiBold(textColor: AppColor.textBackgroundGrey),
                //     counterText: '', // hide default
                //     prefixIcon: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       // Adjust padding as needed
                //       child: SvgPicture.asset(
                //         AppImageSvg.email,
                //         color: Colors.white,
                //         // Path to your SVG file
                //         height: 25,
                //         width: 25,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: AppColor.textBackgroundGrey, // normal state
                //         width: 1,
                //       ),
                //     ),
                //     errorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: Colors.red, // error state
                //         width: 1,
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: AppColor.primaryColor, // focused state
                //         width: 1,
                //       ),
                //     ),
                //     focusedErrorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: Colors.red, // focused + error state
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your email';
                //     } else if (!isValidEmail(value)) {
                //       return 'Enter a valid email address';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 20),
                // TextFormField(
                //   readOnly: false,
                //   obscureText: !isPasswordVisible,
                //   // Toggle password visibility
                //   //textCapitalization: TextCapitalization.characters,
                //   controller: passwordController,
                //   keyboardType: TextInputType.text,
                //   style: CustomTextStyles.semiBold(),
                //   // Input text color
                //   decoration: InputDecoration(
                //     hintText: 'Password',
                //     hintStyle: CustomTextStyles.semiBold(textColor: AppColor.textBackgroundGrey),
                //     // Input text color,
                //     prefixIcon: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       // Adjust padding as needed
                //       child: SvgPicture.asset(
                //         AppImageSvg.lock,
                //         color: Colors.white,
                //         // Path to your SVG file
                //         height: 25,
                //         width: 25,
                //       ),
                //     ),
                //     suffixIcon: IconButton(
                //       icon: Icon(
                //         isPasswordVisible
                //             ? Icons.visibility
                //             : Icons.visibility_off,
                //         color: Colors.white, // Eye icon color
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           isPasswordVisible =
                //               !isPasswordVisible; // Toggle visibility state
                //         });
                //       },
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: AppColor.textBackgroundGrey, // normal state
                //         width: 1,
                //       ),
                //     ),
                //     errorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: Colors.red, // error state
                //         width: 1,
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: AppColor.primaryColor, // focused state
                //         width: 1,
                //       ),
                //     ),
                //     focusedErrorBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //       borderSide: const BorderSide(
                //         color: Colors.red, // focused + error state
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter password';
                //     } else if (value.length < 8) {
                //       return 'Please length should not be less then 8'
                //           ;
                //     } else {
                //       return null;
                //     }
                //   },
                // ),
                SizedBox(height: 20),
                BlocConsumer<LoginBloc, LoginState>(
                  // listener: (context, state) async {
                  //   if (state is LoginSuccess) {
                  //     var data = state.loginModel.data;
                  //     var message = state.loginModel.message;
                  //     var securityCode = data?.securityCode ?? "";
                  //     var userPlanType = data?.userType ?? "";
                  //     var uuid = data?.uuid ?? "";
                  //
                  //     if (uuid.isEmpty) {
                  //       Constant.showErrorDialog(
                  //         context,
                  //         false,
                  //         "UUID is missing",
                  //         () {},
                  //       );
                  //     } else if (userPlanType.isEmpty) {
                  //       Constant.showErrorDialog(
                  //         context,
                  //         false,
                  //         "User type is missing",
                  //             () {},
                  //       );
                  //     } else if (securityCode.isEmpty) {
                  //       Constant.showErrorDialog(
                  //         context,
                  //         false,
                  //         "Security code is missing",
                  //             () {},
                  //       );
                  //     } else {
                  //       await sharedPreferences?.setString(
                  //         PreferenceKey.securityCode,
                  //         securityCode,
                  //       );
                  //       await sharedPreferences?.setString(PreferenceKey.uuid, uuid);
                  //       await sharedPreferences?.setString(
                  //         PreferenceKey.userPlanType,
                  //         userPlanType,
                  //       );
                  //     }
                  //
                  //     await sharedPreferences?.setString(
                  //       PreferenceKey.email,
                  //       emailController.text,
                  //     );
                  //     await sharedPreferences?.setString(
                  //       PreferenceKey.password,
                  //       passwordController.text,
                  //     );
                  //
                  //     if (data != null) {
                  //
                  //       Constant.securityCode = securityCode;
                  //       Constant.userPlanType = userPlanType;
                  //       //Constant.userRole = userRole;
                  //
                  //       await sharedPreferences?.setBool(PreferenceKey.isLogin, true);
                  //       Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => MainScreen(),
                  //         ),
                  //             (route) => false,
                  //       );
                  //
                  //     }
                  //   }
                  //   if (state is LoginError) {
                  //     var message = state.error;
                  //     Constant.showErrorDialog(
                  //       context,
                  //       false,
                  //       message ?? "Something went wrong",
                  //       () {},
                  //     );
                  //   }
                  // },
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
                                // if (_formKey.currentState!.validate()) {
                                //   context.read<LoginBloc>().add(
                                //     UserLoginEvent(
                                //       context: context,
                                //       email: emailController.text,
                                //       password: passwordController.text,
                                //       fcmToken: "",
                                //       deviceId: deviceId,
                                //       deviceType: "mobile",
                                //     ),
                                //   );
                                // }
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
