
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/nameScreen.dart';
import 'package:flutter/material.dart';

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

      removeOverlay();
      return false;
    } else if (_overlayStack.length == 1) {

      Navigator.of(context).pop();
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          child: Icon(Icons.arrow_back_ios, color: Colors.black),
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
                            overflow: TextOverflow.ellipsis,
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
