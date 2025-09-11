import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

import '../../constant/Constant.dart';
import '../../resources/image/appImages.dart';
import '../bottomNavigationScreens/home/feedDetails.dart';
import '../bottomNavigationScreens/home/kudosScreen.dart';
import '../milestone.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
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
        title: Text('Activities', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetails()));
                      },
                      child: Container(
                        color: Colors.white24,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(AppImageOthers.userImg, height: 30,),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jessica Taylor', style: CustomTextStyles.regular(fontSize: 14),),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*.75,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(AppImageOthers.feedRun, height: 16,),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                child: Text('August 15, 2024 at 8:20 AM Iskandar Puteri, Malaysia',
                                                    // maxLines: 2,
                                                    style: CustomTextStyles.regular(fontSize: 11,
                                                        textColor: Colors.grey)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Text('Afternoon Run', style: CustomTextStyles.semiBold(fontSize: 16),),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Distance', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                        Text('10.35 km', style: CustomTextStyles.regular(fontSize: 16)),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Pace', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                        Text('5:51 /km', style: CustomTextStyles.regular(fontSize: 16)),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                        Text('1h 0m', style: CustomTextStyles.regular(fontSize: 16)),
                                      ],
                                    ),
          
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(AppImageOthers.feedImg, fit: BoxFit.fill, height: 260,)),
          
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(/*horizontal: 10.0, */vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Constant.likeImageWidget(),
                                          SizedBox(width: 10,),
                                          Text('8 gave kudos', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
          
                                        ],
                                      ),
          
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                              },
                                              child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(Icons.thumb_up, color: Colors.black,))),
          
                                          SizedBox(width: 10,),
                                          GestureDetector(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Badges()));
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                                              },
                                              child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Icon(Icons.share, color: Colors.black,))),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
          
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     GestureDetector(
                                  //         onTap: () {
                                  //           Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                  //         },
                                  //         child: SizedBox(
                                  //             height: 30,
                                  //             width: 30,
                                  //             child: Icon(Icons.thumb_up, color: Colors.white,))),
                                  //     GestureDetector(
                                  //         onTap: () {
                                  //           Navigator.push(context, MaterialPageRoute(builder: (context) => Discussion()));
                                  //         },
                                  //         child: SizedBox(
                                  //             height: 30,
                                  //             width: 30,
                                  //             child: Icon(Icons.message, color: Colors.white,))),
                                  //     GestureDetector(
                                  //         onTap: () {
                                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => Badges()));
                                  //           Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                                  //         },
                                  //         child: SizedBox(
                                  //             height: 30,
                                  //             width: 30,
                                  //             child: Icon(Icons.share, color: Colors.white,))),
                                  //   ],
                                  // )
                                ],
                              ),
                            ),
                            // SizedBox(height: 20,),
                            // Divider(color: Colors.black,)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
