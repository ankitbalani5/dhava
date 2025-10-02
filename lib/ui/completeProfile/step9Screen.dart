import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/data/createProfileData.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart' show BottomNavBar, bottomNavKey;
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Step9Screen extends StatefulWidget {
  const Step9Screen({super.key});

  @override
  State<Step9Screen> createState() => _Step9ScreenState();
}

class _Step9ScreenState extends State<Step9Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImageOthers.step9Img,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,),
          Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('Welcome, ${CreateProfileData.firstName.capitalize()} ${CreateProfileData.lastName.capitalize()}!',
                    style: CustomTextStyles.boldWorkSens(fontSize: 31, textColor: Colors.white),),
                  SizedBox(height: 5,),
                  Text('150+ million active people on\nStrava are excited to move with you.', textAlign: TextAlign.center, style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.white),),
                  SizedBox(height: 40,),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if(state is UpdateProfileLoading){
                        Constant.loadingDialog(context);
                      }
                      if(state is UpdateProfileSuccess){
                        Constant.closeLoadingDialog(context);
                        Fluttertoast.showToast(msg: state.profileModel.message.toString());
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)), (route) => false,);
                      }
                      if(state is UpdateProfileError){
                        Fluttertoast.showToast(msg: state.error.toString());
                        Constant.closeLoadingDialog(context);
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(text: "Let's go", callback: () {
                        context.read<ProfileBloc>().add(UpdateProfileEvent(context: context,
                          firstName: CreateProfileData.firstName, lastName: CreateProfileData.lastName,
                          dob: CreateProfileData.dob, gender: CreateProfileData.gender, fitnessLevel: CreateProfileData.fitnessLevel,
                          planToUse: CreateProfileData.planToUse, categoryIds: CreateProfileData.categoryIds, 
                        ));

                        // (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(LevelScreen());

                      },);
                    },
                  )
                ],
              )
          )
        ],
      ),
    );
  }

}
extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
