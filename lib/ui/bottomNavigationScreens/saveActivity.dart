
import 'dart:convert';

import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/color/appColor.dart';
import '../../bloc/saveActivityBloc/save_activity_bloc.dart';
import '../../constant/constant.dart';
import '../../repository/api.dart';
import 'endurance.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveActivity extends StatefulWidget {
  final Map<String, dynamic> trackingData;

  const SaveActivity({Key? key, required this.trackingData}) : super(key: key);
  // const SaveActivity({super.key});

  @override
  State<SaveActivity> createState() => _SaveActivityState();
}

class _SaveActivityState extends State<SaveActivity> {
  var _formKey = GlobalKey<FormState>();
  String selectedRunType = '';
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

    await Api.saveActivityApi({
      "category_id": categoryId,
      "title": titleController.text,
      "description": descriptionController.text,
      "distance": widget.trackingData["distance"],
      "pace": widget.trackingData["avgPace"],
      "moving_time": widget.trackingData["time"],
      "city": widget.trackingData["city"],
      "state": widget.trackingData["state"],
      "country": widget.trackingData["country"],
      "address": widget.trackingData["address"],
      "elavation_gain": widget.trackingData["elevationGain"],
      "max_elavation": widget.trackingData["maxElevation"],
      "steps": widget.trackingData["steps"],
      "fastest_split": widget.trackingData["fastestSplit"],
      "path": widget.trackingData["path"],
      "run_type": selectedRunType,
      "type_of_run": selectedTypeOfRun,
      "feeling": selectedFeeling,
      "private_note": privateNoteController.text,
      "gear": selectedGear,
      "visibility": selectedVisibility,
      "hidden_details": selectedHiddenDetails,
      "mute_activity": isPublish,
      "type": "activity",
      "avg_elapsed_pace": widget.trackingData["avgPace"],
      "elapsed_time": widget.trackingData["time"],
      "max_speed": widget.trackingData["maxSpeed"] ?? 0,
      "photo": widget.trackingData["photo"],
    }, context);

    // try {
    //   Uint8List? image = widget.trackingData["mapImage"];
    //
    //   var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse("https://tracking.coherentlab.com/api/v1/activity/save"),
    //   );
    //
    //   Map<String, dynamic> body = {
    //     "category_id": categoryId ?? "", // ya fixed id
    //     "title": titleController.text,
    //     "description": descriptionController.text,
    //     "distance": widget.trackingData["distance"]?.toString() ?? "0",
    //     "elapsed_time": widget.trackingData["time"]?.toString() ?? "0",
    //     "avg_elapsed_pace": widget.trackingData["avgPace"]?.toString() ?? "0",
    //     "fastest_split": widget.trackingData["fastestSplit"]?.toString() ?? "0",
    //     "steps": widget.trackingData["steps"]?.toString() ?? "0",
    //     "elavation_gain": widget.trackingData["elevationGain"]?.toString() ?? "0",
    //     "max_elavation": widget.trackingData["maxElevation"]?.toString() ?? "0",
    //     "path": jsonEncode(widget.trackingData["path"] ?? []),
    //     "run_type": selectedRunType,
    //     "type_of_run": selectedTypeOfRun,
    //     "feeling": selectedFeeling,
    //     "private_note": privateNoteController.text,
    //     "gear": selectedGear,
    //     "visibility": selectedVisibility,
    //     "hidden_details": selectedHiddenDetails,
    //     "mute_activity": isPublish.toString(),
    //     "type": "activity",
    //     "segments": jsonEncode(widget.trackingData["segments"] ?? []),
    //     "splits": jsonEncode(widget.trackingData["splits"] ?? []),
    //     "max_speed": widget.trackingData["maxSpeed"]?.toString() ?? "0",
    //     "avgPace": widget.trackingData["avgPace"]?.toString() ?? "0",
    //   };
    //
    //   body.forEach((key, value) {
    //     request.fields[key] = value.toString();
    //   });
    //
    //   if (image != null) {
    //     request.files.add(http.MultipartFile.fromBytes(
    //       'mapImage',
    //       image,
    //       filename: "tracking_map.png",
    //     ));
    //   }
    //
    //   final response = await request.send();
    //   if (response.statusCode == 200) {
    //     print("Activity uploaded successfully");
    //     final respStr = await response.stream.bytesToString();
    //     print(respStr);
    //   } else {
    //     print("Upload failed: ${response.statusCode}");
    //     final respStr = await response.stream.bytesToString();
    //     print(respStr);
    //   }
    // } catch (e) {
    //   print("Error uploading activity: $e");
    // }

    setState(() => isUploading = false);
  }

  /*Future<void> uploadActivity() async {
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
  }*/

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
  String categoryId = '';

  @override
  void initState() {

    final matchedCategory = Constant.getCategory!.data!
        .firstWhere(
          (element) => element.categoryId == widget.trackingData["runType"],
      orElse: () => CategoryModelData(categoryId: ''), // fallback अगर न मिले
    );

    selectedRunType = matchedCategory.categoryName ?? "";
    categoryId = matchedCategory.categoryId ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Uint8List? image = widget.trackingData["mapImage"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Save Activity', style: CustomTextStyles.bold()),
        // centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black,))/*Center(child: Text('Resume', style: CustomTextStyles.regular(),))*/,
        // leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (image != null)
                //   Image.memory(image, height: 200, fit: BoxFit.cover)
                // else
                //   const Text("No image captured"),
                // ElevatedButton(
                //   onPressed: isUploading ? null : uploadActivity,
                //   child: isUploading
                //       ? CircularProgressIndicator()
                //       : Text("Upload Activity"),
                // ),
                /// title
                TextFormField(
                  controller: titleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.bgTile,
                    hintText: 'Afternoon Run',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixStyle: TextStyle(
                      color: AppColor.textBackgroundGrey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
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
                      return 'Please enter title';
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
                  cursorColor: Colors.black,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  style: TextStyle(color: Colors.black),
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.bgTile,
                    hintText: "How'd it go? Share more about your activity and use @ to tag someone.",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixStyle: TextStyle(
                      color: AppColor.textBackgroundGrey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
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
                      return 'Please enter description';
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
                      // selected category object find करो
                      final selectedCategory = Constant.getCategory?.data
                          ?.firstWhere((element) => element.categoryName == selectedRunType);

                      // categoryId assign करो
                      categoryId = selectedCategory?.categoryId ?? "";
                    });
                  },
                  items: (String? filter, _) => Constant.getCategory?.data
                      ?.map((e) => e.categoryName ?? "")
                      .toList() ?? [],
                  suffixProps: DropdownSuffixProps(
                      dropdownButtonProps: DropdownButtonProps(
                          iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,),
                          iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,)
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
                    baseStyle: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.bgTile,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.directions_run, color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Map & Photo Row
                Container(
                  height: 128,
                  width: double.infinity,
                  child: Image.asset(AppImageOthers.sampleMap, fit: BoxFit.fill, width: double.maxFinite,),
                ),
                const SizedBox(height: 16),

                Image.asset(AppImageOthers.addPhoto),
                // /// Change Map Type Button
                // SizedBox(
                //   height: 50,
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.transparent,
                //       side: const BorderSide(color: AppColor.bgRed),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     onPressed: () {},
                //     child: const Text("Change Map Type", style: TextStyle(color: AppColor.bgRed)),
                //   ),
                // ),
                const SizedBox(height: 24),

                /// Details Section
                const Text("Details", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
                          iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,),
                          iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,)
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
                    baseStyle: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.bgTile,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.waves, color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
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
                          iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,),
                          iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,)
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
                    baseStyle: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.bgTile,
                      // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(AppImageSvg.time)/*Icon(Icons.emoji_emotions_outlined, color: Colors.black)*/,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
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
                  style: TextStyle(color: Colors.black),
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.bgTile,
                    hintText: "Jot down private notes here. Only you can see these.",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 2.0, bottom: 45.0),
                      child: Icon(Icons.lock, color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.red)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  // controller: controller,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your phone number';
                  //   }else {
                  //     return null;
                  //   }
                  // },
                ),
                // SizedBox(height: 15,),
                //
                // /// new gear
                // DropdownSearch<String>(
                //   selectedItem: selectedGear,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedGear = value.toString();
                //     });
                //   },
                //   items: (String? filter, _) => Gear,
                //   suffixProps: DropdownSuffixProps(
                //       dropdownButtonProps: DropdownButtonProps(
                //           iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                //           iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                //       )
                //   ),
                //   popupProps: const PopupProps.menu(
                //     fit: FlexFit.loose,
                //     constraints: BoxConstraints(maxHeight: 200),
                //     showSelectedItems: true,
                //     menuProps: MenuProps(
                //       backgroundColor: Colors.white,
                //     ),
                //   ),
                //   decoratorProps: DropDownDecoratorProps(
                //     baseStyle: TextStyle(color: Colors.white),
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Colors.white24,
                //       // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                //       prefixIcon: Padding(
                //         padding: const EdgeInsets.all(12.0),
                //         child: SvgPicture.asset(AppImageSvg.run, )/*Icon(Icons.run, color: Colors.white)*/,
                //       ),
                //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(14),
                //         borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(14),
                //         borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(14),
                //         borderSide: const BorderSide(color: AppColor.textBackgroundGrey),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 25,),

                const Text("Visibility", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
                          iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,),
                          iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,)
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
                    baseStyle: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.bgTile,
                      // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(AppImageSvg.earth, )/*Icon(Icons.wordpress, color: Colors.black)*/,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
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
                          iconOpened: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,),
                          iconClosed: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black,)
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
                    baseStyle: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.bgTile,
                      // icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: /*SvgPicture.asset(AppImageSvg.run, )*/Icon(Icons.remove_red_eye_outlined, color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),

                const Text("Mute Activity", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                          color: isPublish ? AppColor.bgRed : Colors.white
                        ),
                        child: Center(
                          child: Icon(Icons.check, color: isPublish ? Colors.white : Colors.white,),
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
                    child: Text('Discard Activity', style: CustomTextStyles.bold(fontSize: 14, textColor: AppColor.bgRed),),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.white,
        child: BlocConsumer<SaveActivityBloc, SaveActivityState>(
          listener: (context, state) {
            if (state is SaveActivityLoading) {
              Constant.loadingDialog(context);
              // Loader show करो
            } else if (state is SaveActivitySuccess) {
              Constant.closeLoadingDialog(context);
              Constant.showCongratulationDialog(context);
            } else if (state is SaveActivityError) {
              Constant.closeLoadingDialog(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return CustomButton(
              text: 'Save Activity',
              callback: () {
                if(_formKey.currentState!.validate()){
                  context.read<SaveActivityBloc>().add(
                    SaveActivityPressed(
                      trackingData: widget.trackingData,
                      categoryId: categoryId,
                      title: titleController.text,
                      description: descriptionController.text,
                      runType: selectedRunType,
                      typeOfRun: selectedTypeOfRun,
                      feeling: selectedFeeling,
                      privateNote: privateNoteController.text,
                      gear: selectedGear,
                      visibility: selectedVisibility,
                      hiddenDetails: selectedHiddenDetails,
                      isPublish: isPublish, context: context,

                    ),
                  );
                }

                // uploadActivity();
                // saveActivity();
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Endurance()));
              },
            );
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