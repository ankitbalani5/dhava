
import 'package:coherent_endurance/ui/completeProfile/chooseActivity.dart';
import 'package:coherent_endurance/ui/completeProfile/weightScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/preferenceKey.dart';
import '../../resources/color/appColor.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> with WidgetsBindingObserver {
  // String roleName = Constant.dummyRoleName;
  String gender = ProfileData.gender;
  bool isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    gender = ProfileData.gender.toLowerCase();
    if(gender.isEmpty){
      gender = "male";
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != isKeyboardOpen) {
      setState(() {
        isKeyboardOpen = newValue;
      });
      print("Keyboard open: $isKeyboardOpen");
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Select Your Gender",
                textAlign: TextAlign.center, // Ensures text is centered
                style: CustomTextStyles.semiBold(fontSize: 24),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                textAlign: TextAlign.center,
                "Register your account to track your fitness and manage your progressDrill",
                style: CustomTextStyles.medium(fontSize: 14),
              ),
            ),
            SizedBox(height: 20),

            Container(
              width: screenWidth * 0.60,
              height: screenHeight * 0.50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColor.bgTile
                // gradient: LinearGradient(
                //   colors: [
                //     AppColor.primaryColor.withOpacity(0.2),
                //     AppColor.primaryColor.withOpacity(0.2),
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  genderButton(
                    icon: Icons.male,
                    label: 'Male',
                    value: 'male',
                  ),
                  const SizedBox(height: 15),
                  genderButton(
                    icon: Icons.female,
                    label: 'Female',
                    value: 'female',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isKeyboardOpen
          ? SizedBox()
          : Container(
        height: 60,
        // color: Colors.black,
        child:  CustomButton(
          text: 'Continue',
          callback: () {
            // if (gender.isNotEmpty) {
            //   ProfileData.gender = gender;
              (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(ChooseActivity());
            // } else {
            //   Constant.showErrorDialog(
            //     context,
            //     false,
            //     "Select gender first",
            //         () {},
            //   );
            // }
          },
        ),
      ),
    );
  }

  Widget genderButton({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isSelected = gender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          gender = value;
        });
      },
      child: Container(
        height: screenHeight * 0.22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      AppColor.bgRed, AppColor.bgRed
                      // AppColor.primaryColor.withOpacity(0.2),
                      // AppColor.primaryColor.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : LinearGradient(
                    colors: [

                      AppColor.primaryColor.withOpacity(0.2),
                      AppColor.primaryColor.withOpacity(0.2),
                      // AppColor.backgroundGrey.withOpacity(0.5),
                      // AppColor.backgroundGrey.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          border: Border.all(
            color: AppColor.bgRed/*isSelected ? AppColor.primaryColor : AppColor.backgroundGrey*/,
            width: 1
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value == 'female' ? Column(
                children: [
                  Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 80),
                  const SizedBox(height: 5),
                  Text(
                    label,
                      style: CustomTextStyles.bold(textColor: isSelected ? Colors.white : Colors.black)
                  ),
                ],
              ) :
              Column(
                children: [
                  Text(
                      label,
                      style: CustomTextStyles.bold(textColor: isSelected ? Colors.white : Colors.black)
                  ),
                  SizedBox(height: 5,),
                  Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
