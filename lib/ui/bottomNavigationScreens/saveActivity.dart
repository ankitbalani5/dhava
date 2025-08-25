
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../resources/color/appColor.dart';
import 'endurance.dart';

class SaveActivity extends StatefulWidget {
  const SaveActivity({super.key});

  @override
  State<SaveActivity> createState() => _SaveActivityState();
}

class _SaveActivityState extends State<SaveActivity> {
  String selectedRunType = "Long Run";
  List<String> runTypes = ["Long Run", "Tempo Run", "Intervals", "Recovery Run"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Save Activity', style: CustomTextStyles.bold()),
        centerTitle: true,
        leading: Center(child: Text('Resume', style: CustomTextStyles.regular(),)),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                cursorColor: AppColor.textBackgroundGrey,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                cursorColor: AppColor.textBackgroundGrey,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
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
              DropdownSearch<String>(
                selectedItem: "Run",
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
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[900],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     children: const [
              //       Icon(Icons.directions_run, color: Colors.white),
              //       SizedBox(width: 10),
              //       Text("Run", style: TextStyle(color: Colors.white, fontSize: 16)),
              //       Spacer(),
              //       Icon(Icons.arrow_drop_down, color: Colors.white),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
          
              /// Map & Photo Row
              Row(
                children: [
                  /// Map Sample Box
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "🗺️ This is a sample map.\nYou’ll see your activity map after saving.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
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
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[900],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     children: const [
              //       Icon(Icons.directions_run, color: Colors.white),
              //       SizedBox(width: 10),
              //       Text("Type of run", style: TextStyle(color: Colors.white)),
              //       Spacer(),
              //       Icon(Icons.arrow_drop_down, color: Colors.white),
              //     ],
              //   ),
              // ),
              DropdownSearch<String>(
                selectedItem: "Type of run",
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
                selectedItem: "How did that activity feel?",
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
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[900],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     children: const [
              //       Icon(Icons.emoji_emotions_outlined, color: Colors.white),
              //       SizedBox(width: 10),
              //       Text("How did that activity feel?", style: TextStyle(color: Colors.white)),
              //       Spacer(),
              //       Icon(Icons.arrow_drop_down, color: Colors.white),
              //     ],
              //   ),
              // ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => Endurance()));
          },
        ),
      ),
    );
  }
}
