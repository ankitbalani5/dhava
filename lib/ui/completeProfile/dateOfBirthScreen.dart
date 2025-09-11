
import 'package:coherent_endurance/ui/completeProfile/genderScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/Constant.dart';
import '../../constant/preferenceKey.dart';
import '../../resources/color/appColor.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> with WidgetsBindingObserver {
  final initialDate = DateTime.now();
  // String roleName = Constant.dummyRoleName;
  bool isKeyboardOpen = false;
  late String selectedDay;
  late String selectedMonth;
  late String selectedYear;

  DateTime getDateMinus18Years() {
    final now = DateTime.now();
    final minus18 = DateTime(2000, 1, 1, now.hour, now.minute, now.second);/*DateTime(now.year - 25, now.month, now.day, now.hour, now.minute, now.second);*/
    return minus18;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    var dateOfBirth = ProfileData.dateOfBirth == "" ? getDateMinus18Years() : DateTime.parse(ProfileData.dateOfBirth);

    selectedDay = dateOfBirth.day.toString().padLeft(2, '0');
    selectedMonth = dateOfBirth.month.toString().padLeft(2, '0');
    selectedYear = dateOfBirth.year.toString();
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

    final int selectedYearInt = int.parse(selectedYear);
    final int selectedMonthInt = int.parse(selectedMonth);
    

    final years = List.generate(
      initialDate.year - 1950 + 1,
          (index) => 1950 + index,
    );

    final months = selectedYearInt == initialDate.year
        ? List.generate(initialDate.month, (index) => index + 1)
        : List.generate(12, (index) => index + 1);

    final daysInMonth = DateTime(selectedYearInt, selectedMonthInt + 1, 0).day;

    final days = (selectedYearInt == initialDate.year && selectedMonthInt == initialDate.month)
        ? List.generate(initialDate.day, (index) => index + 1)
        : List.generate(daysInMonth, (index) => index + 1);

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                "Welcome, Naman!",
                textAlign: TextAlign.center, // Ensures text is centered
                style: CustomTextStyles.bold(fontSize: 22),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                "When's Your Birthday?",
                textAlign: TextAlign.center, // Ensures text is centered
                style: CustomTextStyles.bold(fontSize: 22),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              textAlign: TextAlign.center,
              "We'll Use This For Performance Analysis, Filtering\nLeaderboards, And To Keep Younger Users Safe.",
              style: CustomTextStyles.regular(fontSize: 14),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "$selectedDay / $selectedMonth / $selectedYear",
                  style: CustomTextStyles.semiBold(fontSize: 30, textColor: AppColor.textBackgroundGrey),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildPicker(
                      days,
                      int.parse(selectedDay),
                          (value) {
                        setState(() => selectedDay = value.toString().padLeft(2, '0'));
                      },
                    ),
                    buildPicker(
                      months,
                      int.parse(selectedMonth),
                          (value) {
                        setState(() => selectedMonth = value.toString().padLeft(2, '0'));
                      },
                    ),
                    buildPicker(
                      years.map((y) => y).toList(),
                      int.parse(selectedYear),
                          (value) {
                        setState(() => selectedYear = value.toString());
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),

        ],
      ), bottomNavigationBar: isKeyboardOpen
        ? SizedBox()
        : Container(
      height: 60,
      // color: Colors.black,
      child:  CustomButton(
        text: "Continue",
        callback: () {
          var dob = "$selectedYear-$selectedMonth-$selectedDay";
          if (dob.isNotEmpty) {
            // ProfileData.dateOfBirth = dob.toString();
            //
            (context.findAncestorStateOfType<CreateProfileState>())?.addOverlay(GenderScreen());
          } else {
            Constant.showErrorDialog(context, false, "Please Select date of birth", (){});

          }
        },
      ),
    ),
    );
  }

  Widget buildPicker(
      List<int> items,
      int selectedValue,
      ValueChanged<int> onSelectedItemChanged,
      ) {
    final selectedIndex = items.indexOf(selectedValue);

    return Container(
      width: 80,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: [AppColor.primaryColor.withOpacity(0.2), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        itemExtent: 40,
        backgroundColor: Colors.transparent,
        magnification: 1.2,
        onSelectedItemChanged: (index) {
          onSelectedItemChanged(items[index]);
        },
        children:
        items.map((e) {
          return Center(
            child: Text(
              e.toString().padLeft(2, '0'),
              style: CustomTextStyles.semiBold(fontSize: 18, textColor: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}