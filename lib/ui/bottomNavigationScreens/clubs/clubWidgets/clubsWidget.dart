import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/color/appColor.dart';
import '../../../../resources/style/textStyle.dart';


Widget clubsWidget() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(AppImageOthers.clubBanner),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your own coherent endurance club',
                style: CustomTextStyles.semiBold(fontSize: 16),
              ),
              Text(
                'Give your community a motivating home base on coherent endurance.',
                style: CustomTextStyles.regular(
                    fontSize: 11, textColor: Colors.grey),
              ),
              SizedBox(height: 10),
              CustomButton(
                text: 'Get started',
                callback: () {},
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImageOthers.location, height: 30, width: 30),
                  SizedBox(width: 10),
                  Text(
                    'Popular clubs near you',
                    style: CustomTextStyles.medium(fontSize: 16),
                  ),
                ],
              ),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                    mainAxisExtent: 180
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // ✅ Important
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppImageOthers.clubDP, height: 55,),
                        SizedBox(height: 5),
                        Text('Pinkcity Runners', style: CustomTextStyles.semiBold(fontSize: 15),),
                        Row(
                          children: [
                            SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text('545 Runners', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                          ],
                        ),
                        Text('Jaipur, Rajasthan, India', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                        SizedBox(height: 8,),
                        Center(
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.bgRed
                            ),
                            child: Center(
                              child: Text('Join', style: CustomTextStyles.regular(),),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

