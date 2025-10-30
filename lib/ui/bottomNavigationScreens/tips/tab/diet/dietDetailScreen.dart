import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DietDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String type;
  final String dietitian;
  final String description;
  final List<String> keyFeatures;

  const DietDetailScreen({
    super.key,
    required this.imageUrl,
    required this.type,
    required this.dietitian,
    required this.description,
    required this.keyFeatures,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Stack(
            children: [
              ClipRRect(
                borderRadius:  BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                child: Image.asset(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 50,
                left: 15,
                child: GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Image.asset(AppImageOthers.backArrow,width: 30,height: 30,))
              ),
              // Positioned.fill(
              //   child: Center(
              //     child: CircleAvatar(
              //       radius: 28,
              //       backgroundColor: Colors.black54,
              //       child: const Icon(Icons.play_arrow,
              //           color: Colors.white, size: 36),
              //     ),
              //   ),
              // ),
            ],
          ),

          Expanded(
            child: ListView(

              padding: const EdgeInsets.all(16),
              children: [
                /// Type
                Row(
                  children: [
                     SvgPicture.asset(AppImageSvg.diet,color: Colors.black,),
                     SizedBox(width: 6),
                    Text(
                      type,
                      style:  TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                 SizedBox(height: 10),

                /// Title
                Text(
                  dietitian,
                  style:  CustomTextStyles.semiBold(
                      fontSize: 20,
                      textColor: Colors.black87),
                ),
                 SizedBox(height: 10),

                Text(
                  description,
                  style:  TextStyle(fontSize: 14, color: Colors.black87),
                ),
                 SizedBox(height: 16),

                 Text(
                  "Key Features",
                  style: CustomTextStyles.semiBold(
                      fontSize: 20,
                      textColor: Colors.black),
                ),
                 SizedBox(height: 8),
                ...keyFeatures.map(
                      (feature) => Padding(
                    padding:  EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text("• ",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black87)),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   width:250,
          //   padding:  EdgeInsets.all(16),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColor.bgRed,
          //       padding:  EdgeInsets.symmetric(vertical: 14),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8)),
          //     ),
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //          SnackBar(content: Text("Set Up Plan clicked")),
          //       );
          //     },
          //     child:  Text(
          //       "Set Up Plan",
          //       style: CustomTextStyles.semiBold(fontSize: 16, textColor: Colors.white),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
