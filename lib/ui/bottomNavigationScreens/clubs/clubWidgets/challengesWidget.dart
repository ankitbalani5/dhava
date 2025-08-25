import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/style/textStyle.dart';

// Widget challengesWidget(){
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Text('All', style: CustomTextStyles.regular(fontSize: 10),),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(AppImageSvg.walk),
//                       SizedBox(width: 5,),
//                       Text('Walk', style: CustomTextStyles.regular(fontSize: 10),),
//                       SizedBox(width: 5,),
//                       SvgPicture.asset(AppImageSvg.cancel)
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(AppImageSvg.run),
//                       SizedBox(width: 5,),
//                       Text('Run', style: CustomTextStyles.regular(fontSize: 10),),
//                       SizedBox(width: 5,),
//                       SvgPicture.asset(AppImageSvg.cancel)
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(AppImageSvg.cycle),
//                       SizedBox(width: 5,),
//                       Text('Cycle', style: CustomTextStyles.regular(fontSize: 10),),
//                       SizedBox(width: 5,),
//                       SvgPicture.asset(AppImageSvg.cancel)
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 20,),
//           Image.asset(AppImageOthers.challengesBanner),
//           Text('Recommended For You', style: CustomTextStyles.bold(fontSize: 18),),
//           Text('Based on your activities', style: CustomTextStyles.regular(
//               fontSize: 11, textColor: Colors.grey),),
//           SizedBox(height: 20,),
//           GridView.builder(
//             padding: EdgeInsets.zero,
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 mainAxisExtent: 220,
//               ),
//               itemBuilder: (context, index) {
//                 return Image.asset(AppImageOthers.challengeCard);
//               },)
//
//         ],
//       ),
//     ),
//   );
// }

Widget challengesWidget() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('All', style: CustomTextStyles.regular(fontSize: 10)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImageSvg.walk),
                      SizedBox(width: 5),
                      Text('Walk', style: CustomTextStyles.regular(fontSize: 10)),
                      SizedBox(width: 5),
                      SvgPicture.asset(AppImageSvg.cancel),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImageSvg.run),
                      SizedBox(width: 5),
                      Text('Run', style: CustomTextStyles.regular(fontSize: 10)),
                      SizedBox(width: 5),
                      SvgPicture.asset(AppImageSvg.cancel),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImageSvg.cycle),
                      SizedBox(width: 5),
                      Text('Cycle', style: CustomTextStyles.regular(fontSize: 10)),
                      SizedBox(width: 5),
                      SvgPicture.asset(AppImageSvg.cancel),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Image.asset(AppImageOthers.challengesBanner),
          Text('Recommended For You', style: CustomTextStyles.bold(fontSize: 18)),
          Text(
            'Based on your activities',
            style: CustomTextStyles.regular(fontSize: 11, textColor: Colors.grey),
          ),
          SizedBox(height: 20),
          GridView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 220,
            ),
            itemCount: 4, // add count
            itemBuilder: (context, index) {
              return Image.asset(AppImageOthers.challengeCard);
            },
          ),
        ],
      ),
    ),
  );
}
