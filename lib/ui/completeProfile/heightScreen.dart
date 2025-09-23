
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/completeProfile/weightScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ruler_picker/simple_ruler_picker.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> with WidgetsBindingObserver {
  late WeightSliderController _controller;
  // String roleName = Constant.dummyRoleName;
  bool isKeyboardOpen = false;
  double _heightValue = 140;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _heightValue = ProfileData.weight.toDouble();
    _controller = WeightSliderController(initialWeight: _heightValue, minWeight: 0, interval: 1, maxWeight: 1000);
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "What’s your height",
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
            SizedBox(
              height: 400,
              width: 300,
              child: ClipOval(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 🔷 Background Circle
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primaryColor.withOpacity(0.4),
                            AppColor.primaryColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 🔷 Inner Circle for Text
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red.shade200, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Constant.centimeterToFeet(_heightValue.toString()),
                                  style: CustomTextStyles.bold(
                                    fontSize: 36,
                                  ),
                                ),
                                Text(
                                  "Feet",
                                  style: CustomTextStyles.bold(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔷 Ruler picker inside circle
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 16,
                                ),
                                child: VerticalWeightSlider(
                                  controller: _controller,
                                  decoration: const PointerDecoration(
                                    width: 80.0,
                                    height: 5.0,
                                    largeColor: AppColor.textBackgroundGrey,
                                    mediumColor: AppColor.textBackgroundGrey,
                                    smallColor: AppColor.backgroundGrey,
                                    gap: 30.0,
                                  ),
                                  onChanged: (double value) {
                                    setState(() {
                                      _heightValue = value;
                                    });
                                  },
                                  indicator: SvgPicture.asset(AppImageSvg.imageIndicator),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isKeyboardOpen
        ? SizedBox()
        : Container(
      height: 60,
      color: Colors.black,
      child: CustomButton(
        text: 'Continue',
        callback: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)), (route) => false,
          );
          // if (_heightValue != 0) {
          //   // ProfileData.height = _heightValue.toDouble();
          //   (context.findAncestorStateOfType<EditProfileScreenState>())?.addOverlay(WeightScreen());
          // } else {
          //   Constant.showErrorDialog(context, false,  "Select height first", () {});
          // }
        },
      ),
    ),
    );
  }
}
