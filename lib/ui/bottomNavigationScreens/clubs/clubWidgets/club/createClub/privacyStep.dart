import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createAClub.dart';

class PrivacyStep extends StatefulWidget {
  final VoidCallback onNext;
  final ClubModel club;

  const PrivacyStep({super.key, required this.onNext, required this.club});
  @override
  State<PrivacyStep> createState() => PrivacyStepState();
}
class PrivacyStepState extends State<PrivacyStep>{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text("Private or public?", style: CustomTextStyles.regular(fontSize: 20,),),

       SizedBox(height: 20,),
        Text("Privacy", style: CustomTextStyles.regular(fontSize: 14,),),
        optionRadio(
          value: "Public",
          groupValue: widget.club.sport ?? "",
          onChanged: (val) {
            setState(() {
              widget.club.sport = val;
            });
          },
          label: "Public",
          description: "Anyone on endurance can join your club and\nview recent activity and content.",

        ),
        optionRadio(
          value: "Private",
          groupValue: widget.club.sport ?? "",
          onChanged: (val) {
            setState(() {
              widget.club.sport = val;
            });
          },
          label: "Private",
          description: "Anyone on Strava can join your club and \nview recent activity and content.",
        ),

        Spacer(),
        Center(
          child: Text(
            "You can always change this later",
            style: CustomTextStyles.regular(
                fontSize: 12, textColor: AppColor.textBackgroundGrey),
          ),
        ),
        SizedBox(height: 5,),
        Center(
          child: SizedBox(
            width: 250,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.bgRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: widget.onNext,
              child: Text(
                "Next",
                style: CustomTextStyles.semiBold(
                    fontSize: 14, textColor: Colors.white),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget optionRadio({
    required String value,
    required String groupValue,
    required void Function(String?) onChanged,
    required String label,
    required String description,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style:  CustomTextStyles.semiBold(fontSize: 16)),
                    Text(description, style:  TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),

            Radio<String>(
              activeColor: AppColor.bgRed,
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),

          ],
        ),
      ),
    );
  }


}

