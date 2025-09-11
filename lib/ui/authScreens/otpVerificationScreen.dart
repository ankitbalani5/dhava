
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';


import 'package:webview_flutter/webview_flutter.dart';

import '../../bloc/loginBloc/login_bloc.dart';
import '../bottomNavigationScreens/record/trackingScreen.dart';


class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  final defaultPinTheme = PinTheme(
    width: 48,
    height: 48,
    textStyle: CustomTextStyles.bold(),
    decoration: BoxDecoration(
      color: AppColor.textBackgroundGrey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColor.lightGreyImageBackground, width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                    'Enter Verification Code ',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bold(fontSize: 22),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "You'll receive 5 digit code for the\nphone verification",
                    style: CustomTextStyles.smallRegular(),
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // smsRetriever: smsRetriever,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      controller: pinController,
                      focusNode: focusNode,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      // validator: (value) {
                      //   return value != Constant.otp ? 'Pin is incorrect' : null;
                      // },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 2,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      defaultPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: AppColor.textBackgroundGrey,
                        ),
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          // color: AppColor.textBackgroundGrey,
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          // color: AppColor.primaryColor.withOpacity(.2),
                          // border: Border.all(color: Color(0xffFF6F61B5))
                          border: Border.all(
                            color: const Color(0xB5FF6F61), // #FF6F61 at 71% opacity (B5 hex)
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x54FF6F61), // #FF6F61 at 33% opacity (54 hex)
                              blurRadius: 14,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                BlocConsumer<LoginBloc, LoginState>(
                  // listener: (context, state) async {
                  //   if (state is VerifyOtpSuccess) {
                  //
                  //     var message = state.commonResponseModel.message;
                  //     Constant.showErrorDialog(context, true,  message ?? "Something went wrong", () {
                  //       Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => MainScreen()), (route) => false,
                  //       );
                  //     });
                  //
                  //   }
                  //   if (state is VerifyOtpError) {
                  //     var message = state.error;
                  //     Constant.showErrorDialog(context, false,  message ?? "Something went wrong", () {});
                  //   }
                  // },
                  builder: (context, state) {
                    return CustomButton(
                      text:
                      state is VerifyOtpLoading
                          ? ''
                          : 'Verify Number',
                      callback:
                      state is VerifyOtpLoading
                          ? () {}
                          : () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => CreateProfile()), (route) => false,
                        );
                        // //TODO need to check this via otp service
                        // if (_formKey.currentState!.validate()) {
                        //   context.read<LoginBloc>().add(
                        //     VerifyOtpEvent(
                        //       context: context,
                        //       otp: pinController.text,
                        //     ),
                        //   );
                        // }
                      },
                      child:
                      state is VerifyOtpLoading
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

