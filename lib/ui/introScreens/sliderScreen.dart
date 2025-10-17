import 'dart:async';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/data/commonDataModel/commonDataModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/registerScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: 'Running',
      description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
    CommonDataModel(
      image: AppImageOthers.slide2,
      title: 'Cycling',
      description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
    CommonDataModel(
      image: AppImageOthers.slide3,
      title: 'Health Tips',
      description:
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  void startAutoSlide() {
    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_position < splashData.length - 1) {
        _position++;
        pageController.animateToPage(
          _position,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (DragEndDetails details) {
                final velocity = details.primaryVelocity ?? 0;

                // swipe left -> next
                if (velocity < 0) {
                  if (_position < splashData.length - 1) {
                    _position++;
                    pageController.animateToPage(
                      _position,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                    setState(() {});
                  }
                }
                // swipe right -> previous
                else if (velocity > 0) {
                  if (_position > 0) {
                    _position--;
                    pageController.animateToPage(
                      _position,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                    setState(() {});
                  }
                }
              },
              child: Image.asset(
                splashData[_position].image.toString(),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: double.infinity,
              ),
            ),
            // Image.asset(
            //   splashData[_position].image.toString(),
            //   fit: BoxFit.cover,
            //   width: MediaQuery.of(context).size.width,
            // ),
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: splashData.length == 1
                              ? const SizedBox()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashData.length,
                                  (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
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
                  flex: 3,
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    data.title ?? "",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.bold(
                                      textColor: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    data.description ?? "",
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
                        text: 'Login',
                        textColor: Colors.white,
                        callback: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setBool(PrefKey.isFirstTime, true);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()), (route) => false,);
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
