import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()),
        title: Text('Notification', style: CustomTextStyles.bold(),),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(AppImageOthers.defaultImage),
            title: Text('Another activity down', style: CustomTextStyles.bold(fontSize: 16),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Great work out there. Check out your stats now!', style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.grey),),
                Text('4 days ago', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey))
              ],
            ),
          );
      },)
      /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImageSvg.bell),
            SizedBox(height: 20,),
            Text('No Any Notification Yet')
          ]
        ),
      )*/
    );
  }
}
