
import 'package:coherent_endurance/ui/completeProfile/heightScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ruler_picker/simple_ruler_picker.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import 'package:coherent_endurance/constant/constant.dart';
import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'editProfileScreen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> with WidgetsBindingObserver {
  late WeightSliderController _controller;
  // String roleName = Constant.dummyRoleName;
  bool isKeyboardOpen = false;
  double _weightValue = 140;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _weightValue = ProfileData.weight.toDouble();
    _controller = WeightSliderController(initialWeight: _weightValue, minWeight: 0, interval: 1, maxWeight: 1000);
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
                "What’s your weight",
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
                    // Image.asset(AppImageOthers.bigCircle),
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

                    // 🔷 Inner Circle for Text
                    Positioned(
                      top: 70,
                      child: Container(
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
                              _weightValue.toString(),
                              style: CustomTextStyles.bold(
                                fontSize: 36,
                              ),
                            ),
                            Text(
                              "pounds (lbs)",
                              style: CustomTextStyles.bold(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔷 Ruler picker inside circle
                    Positioned(
                      bottom: 20,
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          child: Transform.rotate(
                            angle: 1.5708, // 90 degrees in radians (π/2)
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
                                  _weightValue = value;
                                });
                              },
                              indicator: SvgPicture.asset(AppImageSvg.imageIndicator),
                            ),
                          ),
                        ),
                      ),
                    ),
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
            // if (_weightValue != 0) {
            //   ProfileData.weight = _weightValue.toDouble();
              (context.findAncestorStateOfType<EditProfileScreenState>())?.addOverlay(HeightScreen());
            // } else {
            //   Constant.showErrorDialog(context, false,  "Select weight first", () {});
            // }
          },
        ),
      ),
    );
  }
}
