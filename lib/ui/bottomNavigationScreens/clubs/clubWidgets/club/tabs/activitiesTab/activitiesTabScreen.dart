import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/feedDetails.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/kudosScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivitiesTabScreen extends StatelessWidget {
  const ActivitiesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(

      padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 8,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FeedDetails()));
          },
          child: Container(
            color: Colors.white,
            margin:  EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppImageOthers.userImg, height: 30),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jessica Taylor',
                            style: CustomTextStyles.regular(fontSize: 14)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(AppImageOthers.feedRun, height: 16),
                            SizedBox(width: 5),
                            Text(
                                'August 15, 2024 at 8:20 AM Iskandar\nPuteri, Malaysia',
                                style: CustomTextStyles.regular(
                                    fontSize: 11, textColor: Colors.grey),maxLines: 2),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Afternoon Run',
                    style: CustomTextStyles.semiBold(fontSize: 16)),
                SizedBox(height: 15),

                /// Stats Row
                Row(
                  children: [
                    _stat("Distance", "10.35 km"),
                    SizedBox(width: 20),
                    _stat("Pace", "5:51 /km"),
                    SizedBox(width: 20),
                    _stat("Time", "1h 0m"),
                  ],
                ),
                SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(AppImageOthers.feedImg,
                      fit: BoxFit.fill, height: 260),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        likeImageWidget(),
                         SizedBox(width: 10),
                        Text('8 gave kudos',
                            style: CustomTextStyles.regular(
                                fontSize: 12, textColor: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KudosScreen()));
                            },
                            icon:  Icon(Icons.thumb_up)),
                        IconButton(
                            onPressed: () {},
                            icon:  Icon(Icons.share)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget likeImageWidget (){
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




Widget _stat(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
      Text(value, style: CustomTextStyles.regular(fontSize: 16)),
    ],
  );
}

