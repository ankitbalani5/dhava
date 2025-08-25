import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/material.dart';

import '../resources/style/textStyle.dart';
import '../widgets/backButton.dart';

class Badges extends StatefulWidget {
  const Badges({super.key});

  @override
  State<Badges> createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2021', style: CustomTextStyles.bold(fontSize: 16),),
                Text('9', style: CustomTextStyles.bold(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(AppImageOthers.badge, height: 75,),
                        SizedBox(height: 10,),
                        Text('December 5k', style: CustomTextStyles.semiBold(fontSize: 14),),
                        Text('Dec 2021', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(AppImageOthers.badge, height: 75,),
                        SizedBox(height: 10,),
                        Text('December 5k', style: CustomTextStyles.semiBold(fontSize: 14),),
                        Text('Dec 2021', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(AppImageOthers.badge, height: 75,),
                        SizedBox(height: 10,),
                        Text('December 5k', style: CustomTextStyles.semiBold(fontSize: 14),),
                        Text('Dec 2021', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
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
