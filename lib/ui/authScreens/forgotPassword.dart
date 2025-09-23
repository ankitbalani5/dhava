import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/ui/authScreens/otpScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/loginBloc/login_bloc.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool rememberMe = false;
  var emailController = TextEditingController();

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
                "Forgot Password",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Please Enter Your Email Address To\nRecieve A Verification Code.", style: CustomTextStyles.regular(fontSize: 16, textColor: Colors.black),),
                  // Text("NamanYadav0321@gmail.com", style: CustomTextStyles.bold(fontSize: 16, textColor: Colors.black),),
                ],
              ),
              const SizedBox(height: 60),

              Text('Enter Email', style: CustomTextStyles.medium(fontSize: 14),),
              SizedBox(height: 5,),
              // Password Input
              TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'please enter email';
                  }
                  return null;
                },
                // obscureText: !isVisible,
                decoration: InputDecoration(
                  hintText: "abc@gmail.com",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  // prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                  // suffixIcon: IconButton(
                  //   icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                  //   onPressed: () => setState(() => isVisible = !isVisible),
                  // ),

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
              const SizedBox(height: 20),
              // Center(child: Text('Try Another Way',
              //   style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //       fontFamily: 'InterMedium',
              //       decoration: TextDecoration.underline),))


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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if(state is ForgotPasswordLoading){

            }
            if(state is ForgotPasswordSuccess){
              Fluttertoast.showToast(msg: state.sendOtpModel.data!.otp.toString());
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(email: emailController.text)));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => LoginBloc(),
                    child: OtpScreen(email: emailController.text),
                  ),
                ),
              );

            }
          },
          builder: (context, state) {
            return CustomButton(
              text: state is ForgotPasswordLoading ? '' : 'Send',
              // width: MediaQuery.of(context).size.width,
              // color: Colors.transparent,
              // textColor: Colors.black,
              callback: state is ForgotPasswordLoading
                  ? () {}
                  : () {
                if(_formKey.currentState!.validate()){
                  context.read<LoginBloc>().add(ForgotPasswordEvent(context: context, email: emailController.text));
                }
              },
              child: state is ForgotPasswordLoading
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
      ),
    );
  }
}
