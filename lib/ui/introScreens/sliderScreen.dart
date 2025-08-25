import 'dart:async';

import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/commonDataModel/commonDataModel.dart';
import '../authScreens/loginScreen.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  int _position = 0;
  late Timer timer;
  final PageController pageController = PageController();

  List<CommonDataModel> splashData = [
    CommonDataModel(
      image: AppImageOthers.slide1,
      title: 'Time to Transform Yourself',
      description:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
    CommonDataModel(
      image: AppImageOthers.slide1,
      title: 'Time to Transform Yourself',
      description:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
    CommonDataModel(
      image: AppImageOthers.slide1,
      title: 'Time to Transform Yourself',
      description:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_position < splashData.length - 1) {
        _position++;
      } else {
        _position = 0;
      }

      pageController.animateToPage(
        _position,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    setState(() {}); // Ensure UI updates if needed after initialization
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              splashData[_position].image.toString(),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Positioned.fill(
                      //   child: Image.asset(
                      //     splashData[_position].image.toString(),
                      //     //fit: BoxFit.cover,
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0), // Adjust as needed
                          child: splashData.length == 1
                              ? SizedBox()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashData.length,
                                  (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),

                                width: _position == index ? 15 : 15,
                                height: _position == index ? 5 : 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _position == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: splashData.length,
                          onPageChanged: (index) {
                            setState(() {
                              _position = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            var data = splashData[index];
                            var title = data.title ?? "";
                            var description = data.description ?? "";

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    textAlign: TextAlign.center,
                                    title,
                                    style: CustomTextStyles.bold(
                                      textColor: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.regular(
                                      textColor: AppColor.textLightColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      CustomButton(
                        text: 'Log In',
                        textColor: Colors.white,
                        color: AppColor.primaryColor,
                        callback: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> LoginScreen()));
                        },
                        width: screenHeight * .30,
                      ),
                      SizedBox(height: 15),
                      CustomButton(
                        text: 'Register',
                        textColor: AppColor.primaryColor,
                        color: AppColor.backgroundGrey,
                        callback: () {
                          // Navigator.push(context,MaterialPageRoute(builder: (context)=> RoleScreen()));
                        },
                        width: screenHeight * .30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
