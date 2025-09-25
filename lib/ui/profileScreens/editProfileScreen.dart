import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constant/constant.dart';
import '../../models/profileModel.dart';
import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileModel? profileData;

  TextEditingController birthdayController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String? selectedSport;
  String? primaryCategoryId;
  String gender = '';
  String planToUse = '';
  String fitnessLevel = '';
  List<String> genderList = ["Male", "Female", "Other"];
  @override
  void initState() {
    profileData = Constant.getProfile;
    firstnameController.text = profileData!.data!.firstName.toString();
    lastnameController.text = profileData!.data!.lastName.toString();
    birthdayController.text = profileData!.data!.dob.toString();
    birthdayController.text = Constant.formatDob(birthdayController.text);
    planToUse = profileData!.data!.planToUse!;
    fitnessLevel = profileData!.data!.fitnessLevel!;

    print('gender::${profileData!.data!.gender}');
    final genderValue = profileData?.data?.gender?.toLowerCase();
    final a = genderList.firstWhere(
          (e) => e.toLowerCase() == genderValue,
      orElse: () => "Other", // fallback
    );
    gender = a;

    // final a = genderList.firstWhere((e) => e == profileData!.data?.gender?.toLowerCase().toString());
    // gender = a.toString();
    // .text = profileData!.data!.firstName.toString();
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(UpdateProfileEvent(context: context,
                  firstName: firstnameController.text, lastName: lastnameController.text,
                  city: cityController.text, state: stateController.text,
                  primaryCategoryId: primaryCategoryId.toString(), bio: bioController.text,
                  weight: weightController.text,
                  dob: birthdayController.text, gender: gender, fitnessLevel: fitnessLevel,
                  planToUse: planToUse));
            },
            child: const Text(
              "DONE",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if(state is UpdateProfileLoading){
              Constant.loadingDialog(context);
            }
            if(state is UpdateProfileSuccess){
              Constant.closeLoadingDialog(context);
              Fluttertoast.showToast(msg: state.profileModel.message.toString());
              context.read<ProfileBloc>().add(GetProfileEvent(context, ''));
              Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
            }
            if(state is UpdateProfileError){
              Constant.closeLoadingDialog(context);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        child: CachedNetworkImage(
                          imageUrl: profileData!.data!.profilePhoto.toString(),
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                              Padding(
                                padding:
                                EdgeInsets.all(
                                    40.0),
                                child:
                                CircularProgressIndicator(
                                  color: AppColor.bgRed,
                                  strokeWidth: 1,
                                ),
                              ),
                          errorWidget: (context,
                              url, error) =>
                              Image.asset(AppImageOthers.profilePic, height: 90,),
                        ),
                        // backgroundImage: NetworkImage(
                        //   "https://i.pravatar.cc/300",
                        // ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
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

                // Primary Sport Dropdown
                // _buildDropdown("Primary Sport", "Running", ["Running", "Cycling", "Swimming"]),
                _buildSportDropdown(),
                const SizedBox(height: 15),

                // Bio
                _buildTextField("Bio", bioController),
                // const SizedBox(height: 20),

                // Athlete Information
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "ATHLETE INFORMATION",
                //     style: TextStyle(
                //       fontSize: 13,
                //       color: Colors.grey[600],
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //         "ATHLETE INFORMATION",
                //         style: CustomTextStyles.semiBold(fontSize: 14)
                //     ),
                //     Text('Used To Calculate Calories, Power And More', style: CustomTextStyles.regular(fontSize: 12),),
                //
                //   ],
                // ),
                // const SizedBox(height: 20),
                //
                // // Google Fit Option
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.grey.shade300),
                //   ),
                //   child: Row(
                //     children: const [
                //       Icon(Icons.favorite, color: Colors.red),
                //       SizedBox(width: 10),
                //       Expanded(
                //         child: Text(
                //           "Automatically update your profile by connecting to Google Fit",
                //           style: TextStyle(color: Colors.red, fontSize: 13),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 15),

                // Birthday
                // _buildDropdown("Birthday", "23/08/2000", ["01/01/2000", "23/08/2000", "10/12/2001"]),
                _buildBirthdayField(),
                const SizedBox(height: 15),

                // Gender
                _buildGenderDropdown(),
                // _buildDropdown("Gender", gender, genderList),
                const SizedBox(height: 15),

                // Weight
                _buildTextField("Weight (kg)", weightController),
                const SizedBox(height: 20),

                // Performance Potential Title
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "PERFORMANCE POTENTIAL",
                //       style: CustomTextStyles.semiBold(fontSize: 14)
                //     ),
                //     Text('Used To Set Heart Rate And Running Pace Zones', style: CustomTextStyles.regular(fontSize: 12),),
                //
                //   ],
                // ),
                // const SizedBox(height: 20),
                // // Max Heart Rate
                // _buildTextField("Max Heart Rate (bpm)", bpmController),
                // const SizedBox(height: 15),
                //
                // // Running Race Distance Dropdown
                // _buildDropdown("Running Race Distance", "5K", ["5K", "10K", "Half Marathon"]),
                // const SizedBox(height: 15),
                //
                // // Running Race Time Dropdown
                // _buildDropdown("Running Race Time", "30 mins", ["30 mins", "45 mins", "1 hour"]),
                // const SizedBox(height: 15),
                //
                // // Functional Threshold Power
                // _buildTextField("Functional Threshold Power (watts)", wattsController),
                // const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
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
          backgroundColor: Colors.white, // ✅ popup white
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
          backgroundColor: Colors.white, // ✅ popup white
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
      // dropdownDecoratorProps: DropDownDecoratorProps(
      //   dropdownSearchDecoration: InputDecoration(
      //     labelText: "Primary Sport",
      //     contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(12),
      //       borderSide: BorderSide(color: Colors.grey.shade200),
      //     ),
      //   ),
      // ),
      // popupProps: const PopupProps.menu(
      //   showSearchBox: true,
      // ),
      onChanged: (value) {
        setState(() {
          selectedSport = value;
          // Find selected category object
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
        DateTime(today.year - 18, today.month, today.day); // ✅ min age 18

        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: lastAllowedDate,
          firstDate: DateTime(1900), // कोई भी पुरानी date allow
          lastDate: lastAllowedDate, // सिर्फ 18+ allowed
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
        // hintText: hint,
        // filled: true,
        // fillColor: Colors.grey[100],
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
    );
  }

  // Widget _buildDropdown(String label, String value, List<String> items){
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
