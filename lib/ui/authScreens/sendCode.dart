import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/otpScreen.dart';
import 'package:coherent_endurance/ui/authScreens/passwordScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';

import '../../bloc/loginBloc/login_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:fluttertoast/fluttertoast.dart';

class SendCode extends StatefulWidget {
  String email;
  SendCode({required this.email , super.key});

  @override
  State<SendCode> createState() => _SendCodeState();
}

class _SendCodeState extends State<SendCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImageOthers.sendCode, fit: BoxFit.fill, width: MediaQuery.of(context).size.width,),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.width/3,
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if(state is SendOtpSuccess){
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(email: widget.email)));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => LoginBloc(),
                          child: OtpScreen(email: widget.email),
                        ),
                      ),
                    );

                    Fluttertoast.showToast(msg: state.sendOtpModel.data!.otp.toString());
                  }
                  if(state is SendOtpError){
                    Fluttertoast.showToast(msg: state.error);
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    width: 265,
                    fontSize: 20,
                    text: state is LoginLoading ? '' : 'Email me a code',
                    callback: state is LoginLoading
                        ? () {}
                        : () {
                      context.read<LoginBloc>().add(SendOtpEvent(context: context, email: widget.email));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(email: widget.email)));
                    },
                    child: state is LoginLoading
                        ? Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                        : null,
                  );
                },
              )
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.width/5,
              child: TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordScreen(email: widget.email)));
              }, child: Text('Use Password Instead', style: CustomTextStyles.semiBold(fontSize: 20, textColor: AppColor.bgRed),))
          )
        ],
      ),
    );
  }
}
