
import 'dart:convert';
import 'dart:io';
import 'package:coherent_endurance/bloc/saveActivityBloc/save_activity_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  String? selectedCategoryImage;
  String? categoryName;


  String convertedImage = '';
  File? _selectedImage;
  final ImagePicker picker = ImagePicker();


  Future<void> uploadActivity() async {
    setState(() => isUploading = true);

    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      convertedImage = base64Encode(bytes);
    }

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
      "photo": _selectedImage != null ? convertedImage : widget.trackingData["photo"],
    }, context);

    setState(() => isUploading = false);
  }


  Future<void> saveActivity() async {
    final url = Uri.parse("https://yourapi.com/save-activity");

    final body = {
      ...widget.trackingData, // Tracking data from previous screen

      "title": titleController.text,
      "description": descriptionController.text,
      "runType": selectedRunType,

      "typeOfRun": selectedTypeOfRun,
      "feeling": selectedFeeling,
      "privateNote": privateNoteController.text,
      "gear": selectedGear,

      "visibility": selectedVisibility,
      "hiddenDetails": selectedHiddenDetails,
      "muteActivity": isPublish,

      "createdAt": DateTime.now().toIso8601String(),
      // "mapImage": widget.trackingData["mapImage"],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(data: body),
      ),
    );

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
    categoryName = matchedCategory.categoryName ?? "";
    selectedCategoryImage = matchedCategory.categoryIcon ?? '';
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
            child: Icon(Icons.arrow_back_ios, color: Colors.black,)),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,

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

                TextFormField(
                  controller: descriptionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  cursorColor: Colors.black,

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

                DropdownSearch<String>(
                  selectedItem: selectedRunType,
                  onChanged: (value) {
                    setState(() {
                      selectedRunType = value.toString();
                      final selectedCategory = Constant.getCategory?.data
                          ?.firstWhere((element) => element.categoryName == selectedRunType);

                      categoryId = selectedCategory?.categoryId ?? "";
                      categoryName = selectedCategory?.categoryName ?? "";
                      selectedCategoryImage = selectedCategory?.categoryIcon ?? '';
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
                        child: Image.network(selectedCategoryImage!, height: 25, width: 25,)
                        /*Icon(Icons.directions_run, color: Colors.black),*/
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

                Container(
                  height: 128,
                  width: double.infinity,
                  child:  _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ):Image.asset(AppImageOthers.sampleMap, fit: BoxFit.fill, width: double.maxFinite,),
                ),
                const SizedBox(height:10),

                GestureDetector(
                  onTap: () {
                    _showImageSourceSheet(context);
                  },
                  child:    Image.asset(
                    AppImageOthers.addPhoto,
                    height: 150,
                  ),
                ),





                const SizedBox(height: 20),

                const Text("Details", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

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

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(AppImageSvg.time),
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
                TextFormField(
                  controller: privateNoteController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // keyboardType: TextInputType.number,
                  cursorColor: AppColor.textBackgroundGrey,
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

                ),
                SizedBox(height: 25,),
                const Text("Visibility", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 15,),

                Text('Who can see', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                SizedBox(height: 5,),
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
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>  TrackingScreen(categoryId, categoryName!, selectedCategoryImage!)));
                  },
                  child: Container(
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
              showCongratulationDialog(context);
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
              callback: () async { // ✅ make callback async
                if (_formKey.currentState!.validate()) {

                  String? convertedImage;

                  if (_selectedImage != null) {
                    final bytes = await _selectedImage!.readAsBytes(); // ✅ now you can use await
                    convertedImage = base64Encode(bytes);
                  }

                  widget.trackingData["photo"] = _selectedImage != null ? convertedImage : widget.trackingData["photo"];
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

              },
            );
          },
        ),
      ),
    );
  }
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.gallery);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCongratulationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Image.asset(
                AppImageOthers.trophy,
                height: 180,
              ),

              const SizedBox(height: 20),

              Text(
                  'Congratulation!',
                  style: CustomTextStyles.bold(fontSize: 26, textColor: Colors.black)
              ),
              const SizedBox(height: 10),
              Text(
                'You did a great job in the test!',
                style: CustomTextStyles.regular(textColor: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: 'Continue',
                callback: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)),
                        (route) => false,
                  );
                  bottomNavKey.currentState?.changeTab(0);
                },
              )

            ],
          ),
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