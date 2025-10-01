import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/loginBloc/login_bloc.dart';
import '../../resources/color/appColor.dart';
import '../../widgets/customButton.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  String email;
  CreateNewPasswordScreen({required this.email, super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  var _formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _obscureConfirmPassword = true;

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create New Password",
                  style: CustomTextStyles.bold(
                      fontSize: 28, textColor: Colors.black),
                ),
                const SizedBox(height: 5),
                Text(
                  "Your New Password Must Be Different Previously Used",
                  style: CustomTextStyles.regular(fontSize: 16),
                ),
                const SizedBox(height: 90),
        
                Text('New Password', style: CustomTextStyles.medium(fontSize: 14),),
                SizedBox(height: 5,),
              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                obscureText: _isObscure, // yeh bool control karega
                decoration: InputDecoration(
                  hintText: "**********",
                  filled: true,
                  fillColor: Colors.grey[200],
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

                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
                const SizedBox(height: 15),
                Text('Confirm Password',
                  style: CustomTextStyles.medium(fontSize: 14),),
                SizedBox(height: 5,),
              TextFormField(
                controller: confirmPasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter confirm password';
                  }
                  if (value != confirmPasswordController.text) {
                    return 'please match confirm password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "**********",
                  filled: true,
                  fillColor: Colors.grey[200],

                  // Borders
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

                  // Show/Hide Icon
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
              ),
                const SizedBox(height: 30),
        
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red,
                //     minimumSize: const Size(double.infinity, 50),
                //   ),
                //   child: const Text("Verify Number",
                //       style: TextStyle(color: Colors.white)),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child:
        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if(state is CreatePasswordLoading){

            }
            if(state is CreatePasswordSuccess){
              Fluttertoast.showToast(msg: state.createPasswordModel.message.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => BottomNavBar(key: bottomNavKey)), (route) => false,);
            }
            if(state is CreatePasswordError){
              Fluttertoast.showToast(msg: state.error);
            }
          },
          builder: (context, state) {
            return CustomButton(
              text: state is CreatePasswordLoading ? '' : 'Save',
              // width: MediaQuery.of(context).size.width,
              color: AppColor.bgRed,
              textColor: Colors.white,
              callback: state is CreatePasswordLoading
                  ? () {}
                  : () {
                if(_formKey.currentState!.validate()){

                context.read<LoginBloc>().add(CreatePasswordEvent(
                    context: context, email: widget.email, password: passwordController.text,
                    confirmPassword: confirmPasswordController.text));
                }
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => CreateProfile()));
              },
              child: state is CreatePasswordLoading
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
