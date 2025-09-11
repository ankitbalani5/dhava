import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/createPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../constant/Constant.dart';
import '../../widgets/customButton.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

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

    /// In case you need an SMS autofill feature
    // smsRetriever = SmsRetrieverImpl(
    //   SmartAuth(),
    // );
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
              "Please Enter The 5 Digit Code Sent To\nXyz@gmail.com", style: CustomTextStyles.regular(fontSize: 16),
            ),
            const SizedBox(height: 100),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: List.generate(
            //     4,
            //         (index) => SizedBox(
            //       width: 60,
            //       child: TextField(
            //         textAlign: TextAlign.center,
            //         keyboardType: TextInputType.number,
            //         decoration: InputDecoration(
            //           // filled: true,
            //           // fillColor: Colors.grey[200],
            //
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide: BorderSide(color: Colors.grey),
            //
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide: BorderSide(color: Colors.grey),
            //
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide: BorderSide(color: Colors.grey),
            //
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  defaultPinTheme: defaultPinTheme,
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
              child: Text('Resend Code', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'InterMedium',
                decoration: TextDecoration.underline,),),
            )


          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        // height: 140,
        child: Column(
          children: [
            CustomButton(
              text: 'Verify',
              // width: MediaQuery.of(context).size.width,
              color: AppColor.bgRed,
              textColor: Colors.white,
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()));
              },),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()));
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     minimumSize: const Size(double.infinity, 50),
            //   ),
            //   child: const Text("Email me a code",
            //       style: TextStyle(color: Colors.white)),
            // ),
            // const SizedBox(height: 15),
            //
            // Center(
            //   child: TextButton(
            //     onPressed: () {},
            //     child: Text("Use Password Instead",
            //       style: CustomTextStyles.bold(fontSize: 16, textColor: Colors.black),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
