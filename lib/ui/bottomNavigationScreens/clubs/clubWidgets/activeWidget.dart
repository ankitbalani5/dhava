import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/style/textStyle.dart';

Widget activeWidget(){
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
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
                  child: Text('All', style: CustomTextStyles.regular(fontSize: 10),),
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
                      SizedBox(width: 5,),
                      Text('Walk', style: CustomTextStyles.regular(fontSize: 10),),
                      SizedBox(width: 5,),
                      SvgPicture.asset(AppImageSvg.cancel)
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
                      SizedBox(width: 5,),
                      Text('Run', style: CustomTextStyles.regular(fontSize: 10),),
                      SizedBox(width: 5,),
                      SvgPicture.asset(AppImageSvg.cancel)
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
                      SizedBox(width: 5,),
                      Text('Cycle', style: CustomTextStyles.regular(fontSize: 10),),
                      SizedBox(width: 5,),
                      SvgPicture.asset(AppImageSvg.cancel)
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Stack(
            children: [
              Image.asset(AppImageOthers.activeBanner),
              Positioned(
                top: 0,
                  bottom: 0,
                  left: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('This Year', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                          Text('1', style: CustomTextStyles.regular(fontSize: 16)),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('All Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          Text('39', style: CustomTextStyles.regular(fontSize: 16)),
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
          SizedBox(height: 20,),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  children: [
                    Image.asset(AppImageOthers.activeUser, height: 51,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 210,
                              child: Text('Timeout Streaks Challenge July 2025', style: CustomTextStyles.semiBold(fontSize: 16),)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                                  Text('--/4 weeks', style: CustomTextStyles.regular(
                                      fontSize: 11, textColor: Colors.grey),),
                                ],
                              ),
                              Text('10 days left', style: CustomTextStyles.regular(
                                  fontSize: 11, textColor: Colors.grey),),

                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
          },)

        ],
      ),
    ),
  );
}