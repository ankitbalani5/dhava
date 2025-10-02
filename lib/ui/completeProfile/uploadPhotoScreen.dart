import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/genderScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'createProfile.dart';

File? _uploadImageFile;

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen>  with WidgetsBindingObserver {

  String profileUrl = "";
  bool isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Upload your Profile",
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
            height: 270,
            width: 250,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 🔷 Circular Image
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.textBackgroundGrey,
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: _uploadImageFile != null
                        ? Image.file(
                      _uploadImageFile!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                        : (profileUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: profileUrl,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryColor,
                          strokeWidth: 1,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImageOthers.defaultProfile,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.asset(
                      AppImageOthers.defaultProfile,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),


                Positioned(
                  bottom: -10,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.textBackgroundGrey, width: 1),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: () {
                        handleImageSelection(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
      bottomNavigationBar: isKeyboardOpen
          ? SizedBox()
          : Container(
        height: 60,
        // color: Colors.black,
        child: CustomButton(text: 'Continue', callback: () {
          (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(GenderScreen());
        },),
      ),
    );
  }


  Future<void> handleImageSelection(BuildContext context) async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 14+ flow
      await handlePermissions(
        context: context,
        cameraPermission: Permission.camera,
        galleryPermission: Permission.photos,
      );
    } else {
      // Android 13 and below
      await handlePermissions(
        context: context,
        cameraPermission: Permission.camera,
        galleryPermission: Permission.storage,
      );
    }
  }

  Future<void> handlePermissions({
    required BuildContext context,
    required Permission cameraPermission,
    required Permission galleryPermission,
  })
  async {
    final cameraStatus = await cameraPermission.status;
    final galleryStatus = await galleryPermission.status;

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      // Permissions already granted
      showOptions(context);
    } else if (cameraStatus.isPermanentlyDenied || galleryStatus.isPermanentlyDenied) {
      // Permissions permanently denied
      openAppSettings();
    } else {

      if (cameraStatus.isDenied) {
        await cameraPermission.request();
      }
      if (galleryStatus.isDenied) {
        await galleryPermission.request();
      }


      final newCameraStatus = await cameraPermission.status;
      final newGalleryStatus = await galleryPermission.status;

      if (newCameraStatus.isGranted && newGalleryStatus.isGranted) {
        // Permissions granted after request
        showOptions(context);
      } else if (newGalleryStatus.isLimited) {
        showOptions(context);
      } else {
        Constant.showErrorDialog(
          context,
          false,
          "Permissions are required to continue.",
              () {},
        );

      }
    }
  }

  Future<void> showOptions(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: AppColor.primaryColor.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select File", style: CustomTextStyles.semiBold(textColor: Colors.white)),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: Center(child: Text("Cancel", style: CustomTextStyles.semiBold())),
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library, color: Colors.white,),
                      title: Text(
                        'Photo Library',
                        style: CustomTextStyles.semiBold(textColor: AppColor.textLightColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(context, ImageSource.gallery); // <-- Pick with type
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera, color: Colors.white,),
                      title: Text(
                        'Camera',
                        style: CustomTextStyles.semiBold(textColor: AppColor.textLightColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(context, ImageSource.camera); // <-- Pick with type
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _uploadImageFile = File(pickedFile.path);
      });
    }
  }
}
