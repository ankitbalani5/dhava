import 'package:flutter/material.dart';

import '../../resources/color/appColor.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/backButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String filter = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()),
        title: Text('Statistics', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      filter = 'all';
                      setState(() {
          
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      decoration: BoxDecoration(
                        border: Border.all(color: filter == 'all' ? AppColor.bgRed : Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('All', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'all' ? AppColor.bgRed : Colors.black),),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      filter = 'walk';
                      setState(() {
          
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: filter == 'walk' ? AppColor.bgRed : Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImageSvg.walk, height: 20, color: filter == 'walk' ? AppColor.bgRed : Colors.black,),
                            SizedBox(width: 5,),
                            Text('Walk', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'walk' ? AppColor.bgRed : Colors.black),),
                            SizedBox(width: 5,),
                            SvgPicture.asset(AppImageSvg.cancel, color: filter == 'walk' ? AppColor.bgRed : Colors.black)
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      filter = 'run';
                      setState(() {
          
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: filter == 'run' ? AppColor.bgRed : Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImageSvg.run, color: filter == 'run' ? AppColor.bgRed : Colors.black,),
                            SizedBox(width: 5,),
                            Text('Run', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'run' ? AppColor.bgRed : Colors.black),),
                            SizedBox(width: 5,),
                            SvgPicture.asset(AppImageSvg.cancel, color: filter == 'run' ? AppColor.bgRed : Colors.black,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      filter = 'cycle';
                      setState(() {
          
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: filter == 'cycle' ? AppColor.bgRed : Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImageSvg.cycle, color: filter == 'cycle' ? AppColor.bgRed : Colors.black),
                            SizedBox(width: 5,),
                            Text('Cycle', style: CustomTextStyles.regular(fontSize: 10, textColor: filter == 'cycle' ? AppColor.bgRed : Colors.black),),
                            SizedBox(width: 5,),
                            SvgPicture.asset(AppImageSvg.cancel, color: filter == 'cycle' ? AppColor.bgRed : Colors.black)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40,),
              Text('ACTIVITY', style: CustomTextStyles.semiBold(fontSize: 16),),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.bgTile,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Avg Runs/Week', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('0', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Avg Time/Week', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('0h', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Avg Distance/Week', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('0km', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 20,),
              Text('YEAR-TO-DATE', style: CustomTextStyles.semiBold(fontSize: 16),),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.bgTile,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Runs', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('52', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('37h 6m', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Distance', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('231 Km', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Elev Gain', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('2,105 M', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 20,),
              Text('All TIME', style: CustomTextStyles.semiBold(fontSize: 16),),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.bgTile,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Runs', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('479', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Distance', style: CustomTextStyles.regular(fontSize: 12),),
                          Text('2,600 Km', style: CustomTextStyles.bold(fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
