
import 'dart:convert';

import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/color/appColor.dart';
import 'endurance.dart';
import 'package:http/http.dart' as http;

class SaveActivity extends StatefulWidget {
  final Map<String, dynamic> trackingData;

  const SaveActivity({Key? key, required this.trackingData}) : super(key: key);
  // const SaveActivity({super.key});

  @override
  State<SaveActivity> createState() => _SaveActivityState();
}

class _SaveActivityState extends State<SaveActivity> {
  String selectedRunType = "Run";
  List<String> runTypes = ["Run", "Walk", "Cycle"];
  List<String> TypeOfRun = ["Long Run", "Tempo Run", "Intervals", "Recovery Run"];
  List<String> Feeling = ["Good", "Very Good", "Great"];
  List<String> Gear = ["Default Shoes"];
  List<String> Visibility = ["Everyone", "NoOne"];
  List<String> HiddenDetails = ["None"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController privateNoteController = TextEditingController();
  bool isPublish = false;
  String selectedTypeOfRun = "Tempo Run";
  String selectedFeeling = "Great";
  String selectedGear = "Default Shoes";
  String selectedVisibility = "Everyone";
  String selectedHiddenDetails = "None";


  bool isUploading = false;

  Future<void> uploadActivity() async {
    setState(() => isUploading = true);

    try {
      Uint8List? image = widget.trackingData["mapImage"];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://yourapi.com/upload"),
      );

      // Add normal data
      request.fields['distance'] = widget.trackingData["distance"].toString();
      request.fields['time'] = widget.trackingData["time"].toString();
      request.fields['avgPace'] = widget.trackingData["avgPace"].toString();

      // Attach the image
      if (image != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'mapImage',
          image,
          filename: "tracking_map.png",
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        print("Activity uploaded successfully");
      } else {
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading activity: $e");
    }

    setState(() => isUploading = false);
  }

  // Future<void> saveActivity() async {
  //   final url = Uri.parse("https://yourapi.com/save-activity");
  //
  //   final body = {
  //     ...widget.trackingData, // Tracking screen data
  //     "title": titleController.text,
  //     "description": descriptionController.text,
  //     "runType": selectedRunType,
  //     // "feeling": selectedFeeling,
  //     // "visibility": selectedVisibility,
  //     // "mapType": selectedMapType,
  //     // "photos": uploadedPhotos, // Optional if added
  //   };
  //
  //   // ✅ Directly navigate to ResultScreen with the API payload
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ResultScreen(data: body),
  //     ),
  //   );
  //
  //   // final response = await http.post(
  //   //   url,
  //   //   headers: {"Content-Type": "application/json"},
  //   //   body: json.encode(body),
  //   // );
  //   //
  //   // if (response.statusCode == 200) {
  //   //   print("✅ Activity saved successfully");
  //   //   Navigator.pop(context);
  //   // } else {
  //   //   print("❌ Error saving activity: ${response.body}");
  //   // }
  // }

  Future<void> saveActivity() async {
    final url = Uri.parse("https://yourapi.com/save-activity");

    final body = {
      ...widget.trackingData, // Tracking data from previous screen

      // ✅ Basic Info
      "title": titleController.text,
      "description": descriptionController.text,
      "runType": selectedRunType,

      // ✅ Details Section
      "typeOfRun": selectedTypeOfRun,
      "feeling": selectedFeeling,
      "privateNote": privateNoteController.text,
      "gear": selectedGear,

      // ✅ Visibility Section
      "visibility": selectedVisibility,
      "hiddenDetails": selectedHiddenDetails,
      "muteActivity": isPublish,

      // ✅ Meta Info (Optional future use)
      "createdAt": DateTime.now().toIso8601String(),
      // "mapImage": widget.trackingData["mapImage"],
    };

    // Show JSON in ResultScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(data: body),
      ),
    );

    // If API integration needed, uncomment below:
    /*
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    print("✅ Activity saved successfully");
    Navigator.pop(context);
  } else {
    print("❌ Error saving activity: ${response.body}");
  }
  */
  }


  @override
  Widget build(BuildContext context) {
    Uint8List? image = widget.trackingData["mapImage"];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Save Activity', style: CustomTextStyles.bold()),
        centerTitle: true,
        // leading: Center(child: Text('Resume', style: CustomTextStyles.regular(),)),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                Image.memory(image, height: 200, fit: BoxFit.cover)
              else
                const Text("No image captured"),
              ElevatedButton(
                onPressed: isUploading ? null : uploadActivity,
                child: isUploading
                    ? CircularProgressIndicator()
                    : Text("Upload Activity"),
              ),
              /// title
              TextFormField(
                controller: titleController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: 'Afternoon Run',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixStyle: TextStyle(
                    color: AppColor.textBackgroundGrey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                // controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),

              /// description
              TextFormField(
                controller: descriptionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: "How'd it go? Share more about your activity and use @ to tag someone.",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixStyle: TextStyle(
                    color: AppColor.textBackgroundGrey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                // controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),

              /// type of run
              DropdownSearch<String>(
                selectedItem: selectedRunType,
                onChanged: (value) {
                  setState(() {
                    selectedRunType = value.toString();
                  });
                },
                items: (String? filter, _) => runTypes,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.directions_run, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Map & Photo Row
              Row(
                children: [
                  /// Map Sample Box
                  Expanded(
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(AppImageOthers.sampleMap, fit: BoxFit.fill, width: double.maxFinite,)
                        /*Text(
                          "🗺️ This is a sample map.\nYou’ll see your activity map after saving.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),*/
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// Add Photo/Video Box
                  Expanded(
                    child: DottedBorder(
                      borderType: BorderType.RRect, // 👈 Rounded Rectangle
                      radius: Radius.circular(12), // ✅ Correct property
                      dashPattern: [4, 5],
                      strokeWidth: 1,
                      color: AppColor.bgRed,
                      child: Container(
                        height: 110,
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImageOthers.img, height: 40,),
                              SizedBox(height: 2,),
                              Text(
                                "Add Photos/Video",
                                style: TextStyle(color: AppColor.bgRed),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: DottedBorder(
                  //     options: RectDottedBorderOptions(
                  //       color: Colors.red,
                  //       radius: const Radius.circular(12),
                  //       dashPattern: [4, 5],
                  //       strokeWidth: 1,
                  //       padding: EdgeInsets.all(20),
                  //     ),
                  //     // height: 100,
                  //     // decoration: BoxDecoration(
                  //     //   border: Border.all(color: Colors.redAccent),
                  //     //   borderRadius: BorderRadius.circular(10),
                  //     // ),
                  //     child: Container(
                  //       height: 100,
                  //       child: const Center(
                  //         child: Text(
                  //           "Add Photos/Video",
                  //           style: TextStyle(color: Colors.redAccent),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),

              /// Change Map Type Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: AppColor.bgRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Change Map Type", style: TextStyle(color: AppColor.bgRed)),
                ),
              ),
              const SizedBox(height: 24),

              /// Details Section
              const Text("Details", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              /// Type of Run dropdown
              DropdownSearch<String>(
                selectedItem: selectedTypeOfRun,
                onChanged: (value) {
                  setState(() {
                    selectedTypeOfRun = value.toString();
                  });
                },
                items: (String? filter, _) => TypeOfRun,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.waves, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              /// How did that activity feel? dropdown
              DropdownSearch<String>(
                selectedItem: selectedFeeling,
                onChanged: (value) {
                  setState(() {
                    selectedFeeling = value.toString();
                  });
                },
                items: (String? filter, _) => Feeling,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.emoji_emotions_outlined, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              /// private note
              TextFormField(
                controller: privateNoteController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // keyboardType: TextInputType.number,
                cursorColor: AppColor.textBackgroundGrey,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: "How'd it go? Share more about your activity and use @ to tag someone.",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixStyle: TextStyle(
                    color: AppColor.textBackgroundGrey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: AppColor.textBackgroundGrey)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                // controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),

              /// new gear
              DropdownSearch<String>(
                selectedItem: selectedGear,
                onChanged: (value) {
                  setState(() {
                    selectedGear = value.toString();
                  });
                },
                items: (String? filter, _) => Gear,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(AppImageSvg.run, )/*Icon(Icons.run, color: Colors.white)*/,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),

              const Text("Visibility", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 15,),

              Text('Who can see', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
              SizedBox(height: 5,),

              /// who can see
              DropdownSearch<String>(
                selectedItem: selectedVisibility,
                onChanged: (value) {
                  setState(() {
                    selectedVisibility = value.toString();
                  });
                },
                items: (String? filter, _) => Visibility,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: /*SvgPicture.asset(AppImageSvg.run, )*/Icon(Icons.wordpress, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              Text('Hidden Details', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
              SizedBox(height: 5,),

              /// hidden details
              DropdownSearch<String>(
                selectedItem: selectedHiddenDetails,
                onChanged: (value) {
                  setState(() {
                    selectedHiddenDetails = value.toString();
                  });
                },
                items: (String? filter, _) => HiddenDetails,
                suffixProps: DropdownSuffixProps(
                    dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                        iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                    )
                ),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 200),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: /*SvgPicture.asset(AppImageSvg.run, )*/Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),

              const Text("Mute Activity", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 25,),

              /// don't publish
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Don't publish to Home or Club feeds", style: CustomTextStyles.regular(fontSize: 14),),
                      Text("This activity will still be visible on your profile", style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      isPublish = !isPublish;
                      setState(() {

                      });
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: isPublish ? AppColor.bgRed : Colors.black
                      ),
                      child: Center(
                        child: Icon(Icons.check, color: isPublish ? Colors.white : Colors.black,),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),

              /// discard unsaved changes
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.bgRed,
                  ),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text('Discard unsaved changes', style: CustomTextStyles.bold(fontSize: 14, textColor: AppColor.bgRed),),
                ),
              )


            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.black,
        child: CustomButton(
          text: 'Save Activity',
          callback: () {
            saveActivity();
            // Navigator.push(context, MaterialPageRoute(builder: (context) => Endurance()));
          },
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ResultScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    print(JsonEncoder.withIndent("   ").convert(widget.data));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Uint8List? image = widget.data["mapImage"];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Activity Result",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ✅ Show Map Screenshot at Top
            // if (image != null)
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.memory(
            //       image,
            //       fit: BoxFit.cover,
            //       height: 250,
            //       width: double.infinity,
            //     ),
            //   )
            // else
            //   const Text(
            //     "No Map Image Available",
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                const JsonEncoder.withIndent("   ").convert(widget.data),
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}