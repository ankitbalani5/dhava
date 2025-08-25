
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/ui/completeProfile/uploadPhotoScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  bool isNavigation = Constant.isNavigation;


  @override
  void initState() {
    super.initState();

    // var profileData = isNavigation ? DummyNavigationData.getUserProfileData(Constant.dummyRoleName) : context.read<ProfileBloc>().getProfileResponse?.data;
    // ProfileData.updateProfileData(profileData, Constant.sharedPreferences);
  }

  final List<Widget> _overlayStack = [
    UploadPhotoScreen()
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
    if (_overlayStack.isNotEmpty) {
      // If there are overlays in the stack, remove the last one
      if (_overlayStack.length == 1) {
        Navigator.of(context).pop();
      } else {
        removeOverlay();
      }
      return false; // Prevent default back button behavior
    }
    Navigator.of(context).pop();
    return true; // Allow default behavior if no overlays are present
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                _onWillPop();
              },
              child: BackButtonWidget()
          ),
          title: Text('Register', style: CustomTextStyles.bold(fontSize: 18),),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.primaryColor.withOpacity(0.2),
                ),
                child: Text(
                  "${_overlayStack.length} of 5",
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
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
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
