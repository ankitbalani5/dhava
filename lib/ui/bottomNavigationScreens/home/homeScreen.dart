import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/badges.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/discussion.dart';
import 'package:coherent_endurance/ui/completeProfile/editProfileScreen.dart';
import 'package:coherent_endurance/ui/completeProfile/uploadPhotoScreen.dart';
import 'package:coherent_endurance/ui/milestone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/backButton.dart';
import '../../completeProfile/weightScreen.dart';
import '../../notification/notificationScreen.dart';
import '../../profileScreens/profileScreen.dart';
import 'feedDetails.dart';
import 'kudosScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // leading: BackButtonWidget(),
        title: Text('Home', style: CustomTextStyles.bold(),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.notification,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    AppImageOthers.defaultImage,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetails()));
            },
            child: Container(
              color: Colors.white24,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(AppImageOthers.userImg, height: 30,),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jessica Taylor', style: CustomTextStyles.regular(fontSize: 14),),
                                Row(
                                  children: [
                                    Image.asset(AppImageOthers.feedRun, height: 16,),
                                    SizedBox(width: 5,),
                                    Text('August 15, 2024 at 8:20 AM Iskandar Puteri, Malaysia',
                                        maxLines: 2,
                                        style: CustomTextStyles.regular(fontSize: 11,
                                            textColor: Colors.grey)),
                                  ],
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
                  ),
                  Image.asset(AppImageOthers.feedImg, height: 300,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            likeImageWidget(),
                            SizedBox(width: 10,),
                            Text('8 gave kudos', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
            
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.thumb_up, color: Colors.white,))),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Discussion()));
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.message, color: Colors.white,))),
                            GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Badges()));
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                                },
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.share, color: Colors.white,))),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(color: Colors.black,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget likeImageWidget (){
    return Stack(
      children: [
        Container(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppImageOthers.userImg, height: 30,),
            ],
          ),
        ),

        Positioned(
            right: 25,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
        Positioned(
            right: 50,
            child: Image.asset(AppImageOthers.userImg, height: 30,)),
      ],
    );
  }
}
