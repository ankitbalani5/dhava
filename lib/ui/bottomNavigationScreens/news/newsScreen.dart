import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/news/newsDetail.dart';
import 'package:coherent_endurance/ui/notification/notificationScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constant/Constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        title: Text('News', style: CustomTextStyles.bold(),),
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
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColor.bgRed)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Constant.getProfile?.data?.profilePhoto != null
                          ? CachedNetworkImage(
                        imageUrl:
                        Constant.getProfile?.data?.profilePhoto ?? '',
                        // Replace with your back icon path
                        width: 30,
                        height: 30,
                        placeholder: (context, url) => Image.asset(AppImageOthers.defaultImage,width: 30,
                          height: 30,),
                        errorWidget: (context, url, error) => Image.asset(AppImageOthers.defaultImage,width: 30,
                          height: 30,),
                      ) : Image.asset(AppImageOthers.defaultImage,width: 30,
                        height: 30,),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppImageOthers.newsBanner),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Your Healthy Life Today!', style: CustomTextStyles.bold(fontSize: 14),),
                      Row(
                        children: [
                          Text('Helpful', style: CustomTextStyles.medium(fontSize: 12, textColor: AppColor.bgRed),),
                          SizedBox(width: 5,),
                          Icon(Icons.thumb_up, color: Colors.black , size: 15,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
