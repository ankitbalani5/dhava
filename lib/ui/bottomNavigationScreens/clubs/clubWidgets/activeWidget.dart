// import 'package:coherent_endurance/resources/image/appImages.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../../resources/color/appColor.dart';
// import '../../../../resources/style/textStyle.dart';
//
// Widget activeWidget(){
//   String filter = 'all';
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   filter = 'all';
//                   setState(() {
//
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: filter == 'all' ? AppColor.bgRed : Colors.black),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text('All', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'all' ? AppColor.bgRed : Colors.black),),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   filter = 'walk';
//                   setState(() {
//
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: filter == 'walk' ? AppColor.bgRed : Colors.black),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(AppImageSvg.walk, height: 20, color: filter == 'walk' ? AppColor.bgRed : Colors.black,),
//                         SizedBox(width: 5,),
//                         Text('Walk', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'walk' ? AppColor.bgRed : Colors.black),),
//                         SizedBox(width: 5,),
//                         SvgPicture.asset(AppImageSvg.cancel, color: filter == 'walk' ? AppColor.bgRed : Colors.black)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   filter = 'run';
//                   setState(() {
//
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: filter == 'run' ? AppColor.bgRed : Colors.black),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(AppImageSvg.run, color: filter == 'run' ? AppColor.bgRed : Colors.black,),
//                         SizedBox(width: 5,),
//                         Text('Run', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'run' ? AppColor.bgRed : Colors.black),),
//                         SizedBox(width: 5,),
//                         SvgPicture.asset(AppImageSvg.cancel, color: filter == 'run' ? AppColor.bgRed : Colors.black,)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   filter = 'cycle';
//                   setState(() {
//
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: filter == 'cycle' ? AppColor.bgRed : Colors.black),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(AppImageSvg.cycle, color: filter == 'cycle' ? AppColor.bgRed : Colors.black),
//                         SizedBox(width: 5,),
//                         Text('Cycle', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'cycle' ? AppColor.bgRed : Colors.black),),
//                         SizedBox(width: 5,),
//                         SvgPicture.asset(AppImageSvg.cancel, color: filter == 'cycle' ? AppColor.bgRed : Colors.black)
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 20,),
//           Stack(
//             children: [
//               Image.asset(AppImageOthers.activeBanner),
//               Positioned(
//                 top: 0,
//                   bottom: 0,
//                   left: 10,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('This Year', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
//                           Text('1', style: CustomTextStyles.regular(fontSize: 16)),
//                         ],
//                       ),
//                       SizedBox(width: 20,),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('All Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
//                           Text('39', style: CustomTextStyles.regular(fontSize: 16)),
//                         ],
//                       ),
//                     ],
//                   )
//               )
//             ],
//           ),
//           SizedBox(height: 20,),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: 4,
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 5),
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey)
//                 ),
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
//                     SizedBox(width: 10,),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                               width: 210,
//                               child: Text('Timeout Streaks Challenge July 2025', style: CustomTextStyles.semiBold(fontSize: 16),)),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
//                                   Text('--/4 weeks', style: CustomTextStyles.regular(
//                                       fontSize: 11, textColor: Colors.grey),),
//                                 ],
//                               ),
//                               Text('10 days left', style: CustomTextStyles.regular(
//                                   fontSize: 11, textColor: Colors.grey),),
//
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               );
//           },)
//
//         ],
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import '../../../../resources/color/appColor.dart';
import '../../../../resources/image/appImages.dart';
import '../../../../resources/style/textStyle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActiveWidget extends StatefulWidget {
  const ActiveWidget({Key? key}) : super(key: key);

  @override
  _ActiveWidgetState createState() => _ActiveWidgetState();
}

class _ActiveWidgetState extends State<ActiveWidget> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('all', 'All', null),
                _buildFilterButton('walk', 'Walk', AppImageSvg.walk),
                _buildFilterButton('run', 'Run', AppImageSvg.run),
                _buildFilterButton('cycle', 'Cycle', AppImageSvg.cycle),
              ],
            ),
            // बाकी तुम्हारा code
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String type, String text, String? iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filter = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: filter == type ? AppColor.bgRed : Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                height: 20,
                color: filter == type ? AppColor.bgRed : Colors.black,
              ),
            if (iconPath != null) const SizedBox(width: 5),
            Text(
              text,
              style: CustomTextStyles.regular(
                fontSize: 10,
                textColor: filter == type ? AppColor.bgRed : Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(
              AppImageSvg.cancel,
              color: filter == type ? AppColor.bgRed : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
