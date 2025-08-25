import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/material.dart';

import '../resources/style/textStyle.dart';
import '../widgets/backButton.dart';

class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
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
            child: BackButtonWidget()
        ),
        title: Text('Badges', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(AppImageOthers.milestone, height: 75),
                        SizedBox(height: 10,),
                        Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(AppImageOthers.milestone, height: 75),
                        SizedBox(height: 10,),
                        Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(AppImageOthers.milestone, height: 75),
                        SizedBox(height: 10,),
                        Text('100 Activity', style: CustomTextStyles.bold(fontSize: 16),)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
