import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/material.dart';

import '../../../resources/style/textStyle.dart';
import '../../../widgets/backButton.dart';
import '../../notification/notificationScreen.dart';
import '../../profileScreens/profileScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // leading: GestureDetector(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: BackButtonWidget()),
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
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImageOthers.newsBanner),
                SizedBox(height: 10,),
                Text('Start Your Healthy Life Today!', style: CustomTextStyles.bold(fontSize: 12),),
                SizedBox(height: 10,),
                Text('Kickstart Your Journey To Wellness With Simple,'
                    ' Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple,'
                    ' Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple,'
                    ' Sustainable Habits Now!', style: CustomTextStyles.regular(fontSize: 10, textColor: Colors.grey),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.redAccent, size: 14,),
                        SizedBox(width: 5,),
                        Text('2 Mins Ago', style: CustomTextStyles.medium(fontSize: 10 )),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff531212),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                        child: Center(
                          child: Text('Read More', style: CustomTextStyles.medium(fontSize: 14 )),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
