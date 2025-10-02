import 'package:coherent_endurance/bloc/loginBloc/login_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/createPassword.dart';
import 'package:coherent_endurance/widgets/customButton.dart' show CustomButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  OtpScreen({required this.email, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();


  }
  final defaultPinTheme = PinTheme(
    width: 51,
    height: 51,
    textStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
  );

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
              "Verify Your Email",
              style: CustomTextStyles.bold(fontSize: 28, textColor: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              "Please Enter The 5 Digit Code Sent To\n${widget.email}", style: CustomTextStyles.regular(fontSize: 16),
            ),
            const SizedBox(height: 100),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // smsRetriever: smsRetriever,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),

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
                        color: Colors.black,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.bgRed, width: 2),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.bgRed),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: BlocListener<LoginBloc, LoginState>(
                listenWhen: (previous, current) {

                  return current is SendOtpSuccess && previous is! SendOtpSuccess;
                },
                listener: (context, state) {

                  if(state is SendOtpSuccess){

                    Fluttertoast.showToast(msg: state.sendOtpModel.data!.otp.toString());

                  }
                  if(state is SendOtpError){
                    Fluttertoast.showToast(msg: state.error);
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    context.read<LoginBloc>().add(SendOtpEvent(context: context, email: widget.email));
                  },
                  child: Text('Resend Code', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'InterMedium',
                    decoration: TextDecoration.underline,),),
                ),
              ),
            )


          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        // height: 140,
        child: Column(
          children: [
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if(state is VerifyOtpSuccess){

                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setBool(PrefKey.isLogin, true);
                  pref.setString(PrefKey.accessToken, state.loginResponse.data!.accessToken.toString());
                  pref.setString(PrefKey.refreshToken, state.loginResponse.data!.refreshToken.toString());
                  print('isLogin::::::::::${pref.getBool(PrefKey.isLogin)}');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen(email: widget.email,)));

                }
                if(state is VerifyOtpError){
                  Fluttertoast.showToast(msg: state.error);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: state is VerifyOtpLoading ? '' : 'Verify',

                  color: AppColor.bgRed,
                  textColor: Colors.white,
                  callback: state is VerifyOtpLoading
                      ? () {}
                      : () {
                    if (pinController.text.isEmpty || pinController.text.length < 5) {
                      Fluttertoast.showToast(msg: "Enter your OTP");
                      return;
                    }
                    context.read<LoginBloc>().add(VerifyOtpEvent(context: context, email: widget.email, otp: pinController.text, deviceId: '', fcmToken: '', deviceType: 'mobile'));

                  },
                  child: state is VerifyOtpLoading
                      ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                      : null,
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
