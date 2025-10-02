import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Legal',
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
            Text("Terms and Conditions",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),
            SizedBox(height: 20,),
            Text("Privacy Policy",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),
            SizedBox(height: 20,),
            Text("Copyright",style: CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),),

          ],
        ),
      ),

    );
  }
}
