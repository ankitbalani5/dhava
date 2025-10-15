import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createAClub.dart';

class CustomizeStep extends StatefulWidget {
  final VoidCallback onNext;
  final ClubModel club;

  const CustomizeStep({super.key, required this.onNext, required this.club});

  @override
  State<CustomizeStep> createState() => _CustomizeStepState();
}

class _CustomizeStepState extends State<CustomizeStep> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                 Text(
                  "Customize your club",
                  style: CustomTextStyles.regular(
                    fontSize: 20,
                  ),
                ),
                 SizedBox(height: 6),
                 Text(
                  "Choose a club name, add a photo and write a description.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                 SizedBox(height: 20),

                // Upload Photo box
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color:  AppColor.bgTile,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.image_outlined,
                          size: 40, color: AppColor.bgRed),
                      SizedBox(height: 8),
                      Text(
                        "Upload Photo",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.bgRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 24),

                // Club Name
                 Text(
                  "Club Name *",
                   style: CustomTextStyles.semiBold(
                     fontSize: 14,
                   ),
                ),
                 SizedBox(height: 8),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 126,
                  decoration: InputDecoration(
                    hintText: "Give your club a name",
                    hintStyle:  TextStyle(color: Colors.black45),
                    filled: true,
                    fillColor:   AppColor.bgTile,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    counterText: "126 characters remaining",
                    counterStyle:  TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
                 SizedBox(height: 16),

                // Description
                 Text(
                  "Description",
                  style:  CustomTextStyles.semiBold(
                   fontSize: 14,
                 ),
                ),
                 SizedBox(height: 8),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 126,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle:  TextStyle(color: Colors.black45),
                    filled: true,
                    fillColor:  AppColor.bgTile,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    counterText: "126 characters remaining",
                    counterStyle:  TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
                 SizedBox(height: 16),
                 Center(
                  child: Text(
                    "You can always change this later",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                 SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child:  Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
