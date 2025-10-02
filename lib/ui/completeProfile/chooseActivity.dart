import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/data/createProfileData.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/step5Screen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'createProfile.dart';

class ChooseActivity extends StatefulWidget {
  const ChooseActivity({super.key});

  @override
  State<ChooseActivity> createState() => _ChooseActivityState();
}


class _ChooseActivityState extends State<ChooseActivity> {
  List<String> selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What Types Of Activities \nDo You Like To Do?",
            style: CustomTextStyles.bold(fontSize: 22, textColor: Colors.black),
          ),
          SizedBox(height: 20),
          Text(
            "Here's A Peek At What Coherent Has To Offer. When It's Time To Record An Activity, You Can Choose From Over 30 Sport Types.",
            style: CustomTextStyles.regular(fontSize: 14),
          ),
          SizedBox(height: 50),
          ListView.builder(
            shrinkWrap: true,
            itemCount: Constant.getCategory!.data!.length,
            itemBuilder: (context, index) {
              final category = Constant.getCategory!.data![index];
              final isSelected = selectedActivities.contains(category.categoryId);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {

                      selectedActivities.remove(category.categoryId);
                    } else {

                      selectedActivities.add(category.categoryId.toString());
                    }
                  });
                },
                child: Container(
                  height: 85,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? AppColor.bgRed.withOpacity(.5)
                        : AppColor.bgTextField,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: category.categoryIcon.toString(),
                              height: 32,
                              width: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category.categoryName.toString(),
                              style: CustomTextStyles.semiBold(fontSize: 21),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CustomButton(
          text: 'Continue',
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {
            if (selectedActivities.isNotEmpty) {
              CreateProfileData.categoryIds = selectedActivities.join(",");

              print(CreateProfileData.categoryIds);
              (context.findAncestorStateOfType<CreateProfileState>())
                  ?.addOverlay(Step5Screen());
            } else {
              Fluttertoast.showToast(
                  msg: 'please select at least one activity that you like');
            }
          },
        ),
      ),
    );
  }
}
