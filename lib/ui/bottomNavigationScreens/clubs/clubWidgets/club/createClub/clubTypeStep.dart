import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createAClub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ClubTypeStep extends StatefulWidget {
  final VoidCallback onNext;
  final ClubModel club;

  const ClubTypeStep({super.key, required this.onNext, required this.club});
  @override
  State<ClubTypeStep> createState() => _ClubTypeState();
}

  class _ClubTypeState extends State<ClubTypeStep> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("How would you describe your club?",
                  style: CustomTextStyles.regular(fontSize: 20)),
              Text(
                "broad with All Sports or be specific with one sport type.",
                style: CustomTextStyles.regular(fontSize: 11),
              ),

              sportOption(
                value: "All Sports",
                groupValue: widget.club.sport ?? "",
                onChanged: (val) {
                  setState(() {
                    widget.club.sport = val;
                  });
                },
                label: "All Sports",
                description: "",
                icon: SizedBox(width:30,child: Image.asset(AppImageOthers.allSportImg)) ,
              ),

              sportOption(
                  value: "Running",
                  groupValue: widget.club.sport ?? "",
                  onChanged: (val) {
                    setState(() {
                      widget.club.sport = val;
                    });
                  },
                  label: "Running",
                  description: "Run, Virtual Run, Wheelchair, \nTrail Run",
                  icon: SvgPicture.asset(AppImageSvg.run,width: 30,color: Colors.black,)
              ),

              sportOption(
                value: "Cycling",
                groupValue: widget.club.sport ?? "",
                onChanged: (val) {
                  setState(() {
                    widget.club.sport = val;
                  });
                },
                label: "Cycling",
                description: "Handcycle, E-Bike Ride, Gravel Ride,\nVirtual Ride, Velomobile Ride,\nMountain Bike Ride,\nE-Mountain Bike Ride, Ride",
                icon: SizedBox(width:30,child: Image.asset(AppImageOthers.cycleImg)) ,
              ),
              sportOption(
                value: "Walking",
                groupValue: widget.club.sport ?? "",
                onChanged: (val) {
                  setState(() {
                    widget.club.sport = val;
                  });
                },
                label: "Walking",
                description: "Run, Virtual Run, Wheelchair, \nTrail Run",
                icon: SizedBox(width:30,child: Image.asset(AppImageOthers.walkingImg)) ,
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
          ),
        ),
      );
    }

    Widget sportOption({
      required String value,
      required String groupValue,
      required void Function(String?) onChanged,
      required String label,
      required String description,
      required Widget icon,  // ab ye widget h (Image.asset / SvgPicture / Icon)
    }) {
      return InkWell(
        onTap: () => onChanged(value),
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,  // yaha direct use karo
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style:  TextStyle(fontSize: 16)),
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


