import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
        title: Text('Settings', style: CustomTextStyles.bold(fontSize: 18),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Support', style: CustomTextStyles.regular(fontSize: 14),),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
            ),
            ListTile(
              title: Text('About Coherent Endurance', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
            ),
            ListTile(
              title: Text('Terms and Conditions', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
            ),
            ListTile(
              title: Text('Privacy Policy', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
            ),
            ListTile(
              title: Text('Delete Your Account', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
