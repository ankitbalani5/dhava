import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createAClub.dart';
import 'package:flutter/material.dart';


class LocationStep extends StatefulWidget {

  final ClubModel club;

  LocationStep({super.key,  required this.club});

  State<LocationStep> createState() => LocationStepState();
}

class LocationStepState extends State<LocationStep>{

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text("Where is your club located?", style: CustomTextStyles.regular(fontSize: 20,),),
        Text("Pick Global if your club isn't tied to one spot.",
          style: CustomTextStyles.regular(fontSize: 11),
        ),
        SizedBox(height: 80,),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding:  EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30,child: Image.asset(AppImageOthers.globImg,color: Colors.white,)),
                SizedBox(width: 10,),
                Text("Global",
                  style: CustomTextStyles.bold(fontSize: 16,textColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColor.bgTile,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding:  EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30,child: Image.asset(AppImageOthers.dropLocation,color: Colors.black,)),

                Text("Choose a location",
                  style: CustomTextStyles.bold(fontSize: 16,textColor: Colors.black),
                ),
                Text("Select",
                  style: CustomTextStyles.bold(fontSize: 16,textColor: Colors.black),
                ),
              ],
            ),
          ),
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
              onPressed: (){
                ClubDialogBox.showClubDialog(context);
              },
              child: Text(
                "Create Club",
                style: CustomTextStyles.semiBold(
                    fontSize: 14, textColor: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ClubDialogBox {
  static void showClubDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      AppImageOthers.clubDialogImg,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

               SizedBox(height: 16),

               Text(
                "Congrats! You Created a Club",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 8),

               Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Invite your community, write a post, create an — it’s your club!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),

               SizedBox(height: 16),

              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Yaha apna navigation ya dusra logic dalna
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Get Started Clicked!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:AppColor.bgRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


