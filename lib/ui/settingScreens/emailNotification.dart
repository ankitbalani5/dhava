import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class EmailNotification extends StatefulWidget {
  const EmailNotification({super.key});

  @override
  State<EmailNotification> createState() => _EmailNotificationState();
}

class _EmailNotificationState extends State<EmailNotification> {
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
        title: Text('Email notification', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Once in a while, we'd like to email you quick updates about new features."
                " Personalized data visualizations or promotions and offers from Coherent"
                " Endurance and its partners that we think you'll appreciate, And it's just some"
                " fun between us we don't share or sell your contact information and you can change"
                " these settings at any time.", style: CustomTextStyles.regular(fontSize: 14),),
            SizedBox(height: 35,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coherent Updates', style: CustomTextStyles.semiBold(fontSize: 14),),
                Switch(value: false, onChanged: (value) {

                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}
