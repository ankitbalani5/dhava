import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coherent_endurance/bloc/updateProfileBloc/update_profile_bloc.dart';
import '../../constant/constant.dart';
import '../../models/profileModel.dart';
import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileModel? profileData;
  File? _selectedImage;

  final ImagePicker picker = ImagePicker();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String? selectedSport;
  String? primaryCategoryId;
  String? userID = '';
  String gender = '';
  String planToUse = '';
  String fitnessLevel = '';
  List<String> genderList = ["Male", "Female", "Other"];
  late String profilePic ;




  @override
  void initState() {

    profileData = context.read<ProfileBloc>().profileModel;
    firstnameController.text = profileData!.data!.firstName.toString();
    lastnameController.text = profileData!.data!.lastName.toString();
    birthdayController.text = profileData!.data!.dob.toString();
    cityController.text = profileData!.data!.city.toString();
    stateController.text = profileData!.data!.state.toString();
    bioController.text = profileData!.data!.bio.toString();
    weightController.text = profileData!.data!.weight.toString();
    // primaryCategoryId = profileData!.data!.primaryCategoryId.toString();
    birthdayController.text = Constant.formatDob(birthdayController.text);
    planToUse = profileData?.data?.planToUse ??"";
    fitnessLevel = profileData?.data?.fitnessLevel??"";
    profilePic = profileData?.data?.profilePhoto??"";
    final profileCategoryId = profileData?.data?.primaryCategoryId;
    userID  =profileData?.data?.userId.toString();



    if(profileCategoryId != null){
      final category = Constant.getCategory?.data?.firstWhereOrNull((e) => e.categoryId == profileCategoryId);
      selectedSport = category?.categoryName ?? '';
    }else{
      selectedSport = "profileCategoryId is null";
    }

    final genderValue = profileData?.data?.gender?.toLowerCase() ?? '';
    final a = genderList.firstWhere(
          (e) => e.toLowerCase() == genderValue,
      orElse: () => "Other",
    );

    print('gender:: $a');
    gender = a;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackButtonWidget()),

        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
        actions: [
          BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
            listener: (context, state) async {
              if (state is UpdateProfileLoading) {
                Constant.loadingDialog(context);
              }

              if (state is UpdateProfileSuccess) {
                Constant.closeLoadingDialog(context);
                Fluttertoast.showToast(msg: state.profileModel.message.toString());

                Navigator.pop(context);  // if you want to go back after update

                context.read<ProfileBloc>().profileModel = null;
                context.read<ProfileBloc>().add(GetProfileEvent(context, ''));
              }

              if (state is UpdateProfileError) {
                Constant.closeLoadingDialog(context);
                Fluttertoast.showToast(msg: state.error);
              }
            },

            builder: (context,state){
              return    TextButton(
                onPressed: () async {

                  context.read<ProfileBloc>().profileModel = null;
               String? imagePathToSend = _selectedImage?.path;

                  context.read<UpdateProfileBloc>().add(UpdateProfileEvent(
                    context: context,
                    firstName: firstnameController.text,
                    lastName: lastnameController.text,
                    city: cityController.text,
                    state: stateController.text,
                    profilePic: imagePathToSend,
                    primaryCategoryId: primaryCategoryId.toString(),
                    bio: bioController.text,
                    weight: weightController.text,
                    dob: birthdayController.text,
                    gender: gender,
                    fitnessLevel: fitnessLevel,
                    planToUse: planToUse,

                  ));
                },
                child:  Text(
                  "DONE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture

            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade200,
                    child: _selectedImage != null
                        ? ClipOval(
                      child: Image.file(
                        _selectedImage!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                        : (profilePic.isNotEmpty)
                        ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: profilePic, // use String URL
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(
                            color: AppColor.bgRed,
                            strokeWidth: 1,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppImageOthers.profilePic,
                          height: 90,
                        ),
                      ),
                    )
                        : ClipOval(
                      child: Image.asset(
                        AppImageOthers.profilePic,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),



                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: (){
                        _showImageSourceSheet(context);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // First Name & Last Name
            Row(
              children: [
                Expanded(child: _buildTextField("First name", firstnameController)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("Last name", lastnameController)),
              ],
            ),
            const SizedBox(height: 15),

            // City & State
            Row(
              children: [
                Expanded(child: _buildTextField("City", cityController)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("State", stateController)),
              ],
            ),
            const SizedBox(height: 15),

            _buildSportDropdown(),
            const SizedBox(height: 15),

            // Bio
            _buildTextField("Bio", bioController),

            const SizedBox(height: 15),

            _buildBirthdayField(),
            const SizedBox(height: 15),

            // Gender
            _buildGenderDropdown(),

            // _buildDropdown("Gender", gender, genderList),
            const SizedBox(height: 15),


            _buildTextField("Weight (kg)", weightController),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
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


  Widget _buildGenderDropdown() {
    return DropdownSearch<String>(
      items: (filter, loadProps) => genderList,
      selectedItem: gender,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "Gender",
          labelStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // borderSide: BorderSide.none,
              borderSide: BorderSide(color: Colors.grey.shade200)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // borderSide: BorderSide.none,
              borderSide: BorderSide(color: Colors.grey.shade200)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // borderSide: BorderSide.none,
              borderSide: BorderSide(color: Colors.grey.shade200)
          ),
        ),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        menuProps: MenuProps(
          backgroundColor: Colors.white,
        ),
      ),
      onChanged: (value) {
        setState(() {
          gender = value ?? "Other";
        });
      },
    );
  }


  Widget _buildSportDropdown() {
    return DropdownSearch<String>(
      items: (filter, loadProps) => Constant.getCategory?.data
          ?.map((e) => e.categoryName ?? "")
          .toList() ?? [],
      selectedItem: selectedSport,
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        menuProps: MenuProps(
          backgroundColor: Colors.white,
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Primary Sport",
            labelStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // borderSide: BorderSide.none,
                borderSide: BorderSide(color: Colors.grey.shade200)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // borderSide: BorderSide.none,
                borderSide: BorderSide(color: Colors.grey.shade200)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // borderSide: BorderSide.none,
                borderSide: BorderSide(color: Colors.grey.shade200)
            ),
          ),
      ),

      onChanged: (value) {
        setState(() {
          selectedSport = value;

          final selectedCategory = Constant.getCategory?.data!.firstWhere(
                  (element) => element.categoryName == value,
              // orElse: () => CategoryModel(categoryId: "", categoryName: "")
          );

          primaryCategoryId = selectedCategory!.categoryId.toString();
        });
      },
    );
  }

  Widget _buildBirthdayField() {
    return TextField(
      controller: birthdayController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Birthday",
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
      ),
      onTap: () async {
        final DateTime today = DateTime.now();
        final DateTime lastAllowedDate =
        DateTime(today.year - 18, today.month, today.day);

        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: lastAllowedDate,
          firstDate: DateTime(1900),
          lastDate: lastAllowedDate,
        );

        if (picked != null) {
          setState(() {
            birthdayController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          });
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: controller == weightController ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),

        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),

            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),

            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
      ),
    );
  }


  Widget _buildDropdown(String label, String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          // labelText: label,
          label: Text(label),
          labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (newValue) {},
      ),
    );
  }
}
