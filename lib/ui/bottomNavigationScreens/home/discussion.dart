import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class Discussion extends StatefulWidget {
  const Discussion({super.key});

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
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
        title: Text('Discussion', style: CustomTextStyles.bold(),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppImageOthers.discussionMap),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white24,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Afternoon Run', style: CustomTextStyles.semiBold(fontSize: 16),),
                  Text('Abhishek Kumar . 8/6/25 . 10.8 Km', style: CustomTextStyles.regular(
                      fontSize: 14, textColor: Colors.grey),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('0', style: CustomTextStyles.regular(fontSize: 14))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
