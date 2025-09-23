
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/ui/completeProfile/nameScreen.dart';
import 'package:coherent_endurance/ui/completeProfile/uploadPhotoScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => CreateProfileState();
}

class CreateProfileState extends State<CreateProfile> with SingleTickerProviderStateMixin {
  bool isNavigation = Constant.isNavigation;


  @override
  void initState() {
    super.initState();

    // var profileData = isNavigation ? DummyNavigationData.getUserProfileData(Constant.dummyRoleName) : context.read<ProfileBloc>().getProfileResponse?.data;
    // ProfileData.updateProfileData(profileData, Constant.sharedPreferences);
  }

  final List<Widget> _overlayStack = [
    // UploadPhotoScreen()
    NameScreen()
  ];

  void addOverlay(Widget screen) {
    setState(() {
      _overlayStack.add(screen);
    });
  }

  void removeOverlay() {
    setState(() {
      if (_overlayStack.isNotEmpty) {
        _overlayStack.removeLast();
      }
    });
  }

  void clearOverlay() {
    setState(() {
      if (_overlayStack.isNotEmpty) {
        _overlayStack.clear();
      }
    });
  }

  int getOverlayCount() {
    return _overlayStack.length;
  }

  Future<bool> _onWillPop() async {
    if (_overlayStack.length > 1) {
      // Agar ek se zyada overlays hai to last remove karo
      removeOverlay();
      return false; // system back ko consume kar lo
    } else if (_overlayStack.length == 1) {
      // Agar last overlay bacha hai to poora screen band karo
      Navigator.of(context).pop();
      return true;
    }
    return true;
  }

  // Future<bool> _onWillPop() async {
  //   if (_overlayStack.isNotEmpty) {
  //     // If there are overlays in the stack, remove the last one
  //     if (_overlayStack.length == 1) {
  //       Navigator.of(context).pop();
  //     } else {
  //       removeOverlay();
  //     }
  //     return false; // Prevent default back button behavior
  //   }
  //   Navigator.of(context).pop();
  //   return true; // Allow default behavior if no overlays are present
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   //backgroundColor: Colors.white,
        //   leading: GestureDetector(
        //       onTap: () {
        //         _onWillPop();
        //       },
        //       child: BackButtonWidget()
        //   ),
        //   leadingWidth: 30,
        //   title: Text('Profile Completion', style: CustomTextStyles.bold(fontSize: 18),),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 10.0,
        //           vertical: 5,
        //         ),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(5),
        //           color: AppColor.primaryColor.withOpacity(0.2),
        //         ),
        //         child: Text(
        //           "${_overlayStack.length} of 6",
        //           style: CustomTextStyles.semiBold(
        //             fontSize: 14,
        //             textColor: AppColor.primaryColor,
        //           ),
        //           textAlign: TextAlign.center,
        //           maxLines: 1,
        //           // Match `android:singleLine="true"`
        //           overflow: TextOverflow.ellipsis, // Prevent overflow
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: _overlayStack.length == 5 || _overlayStack.length == 8 || _overlayStack.length == 9 ? 0 : 20.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _overlayStack.length == 5 || _overlayStack.length == 8 || _overlayStack.length == 9 ? SizedBox() : Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            _onWillPop()
                          },
                          child: Icon(Icons.arrow_back_ios, color: Colors.black),/*SvgPicture.asset(
                            AppImageSvg.backArrow,
                            width: 25,
                            height: 25,
                            color: Colors.black,
                          ),*/
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text("Profile Completion", style: CustomTextStyles.bold()),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.primaryColor.withOpacity(0.2),
                          ),
                          child: Text(
                            "${_overlayStack.length} of ${Constant.getProfileScreenCount()}",
                            style: CustomTextStyles.semiBold(
                              fontSize: 14,
                              textColor: AppColor.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            // Match `android:singleLine="true"`
                            overflow: TextOverflow.ellipsis, // Prevent overflow
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                // SizedBox(height: 20),
                Expanded(
                  child: Stack(
                    children: [
                      ..._overlayStack, // Overlay screens
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
