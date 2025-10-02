import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'About',
          style: CustomTextStyles.bold(),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About",style: CustomTextStyles.semiBold(textColor: AppColor.lightGreyImageBackground),),
            SizedBox(height: 20,),
            Text("Version",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),
            Text("Strava Version 427.12 (12393974)",style: CustomTextStyles.regular(textColor: AppColor.backgroundGrey),),
            SizedBox(height: 20,),
            Text("Rate this app",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),

            SizedBox(height: 20,),
            Text("Maps on Endurance",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),

            SizedBox(height: 20,),
            Divider(height: 20,thickness: 2,color: AppColor.bgTextField,),
            SizedBox(height: 20,),
            Text("About the Company",style: CustomTextStyles.semiBold(textColor: AppColor.lightGreyImageBackground),),
            SizedBox(height: 20,),
            Text("About Endurance",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),
          ],
        ),
      ),

    );
  }
}
