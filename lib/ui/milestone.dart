
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';


class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  List<Map<String, String>> milestone = [
    {"image": AppImageOthers.milestone, "title": "10th Activity"},
    {"image": AppImageOthers.milestone, "title": "100th Activity"},
    {"image": AppImageOthers.milestone, "title": "150th Activity"},
    {"image": AppImageOthers.milestone, "title": "200th Activity"},
    {"image": AppImageOthers.milestone, "title": "300th Activity"},
    {"image": AppImageOthers.milestone, "title": "400th Activity"},
    {"image": AppImageOthers.milestone, "title": "400th Activity"},
    {"image": AppImageOthers.milestone, "title": "400th Activity"},
    {"image": AppImageOthers.milestone, "title": "400th Activity"},
  ];
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
            child: BackButtonWidget()
        ),
        title: Text('Milestones', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [

              buildBadgeGrid(milestone),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildBadgeGrid(List<Map<String, String>> badges) {
    List<Widget> rows = [];

    for (int i = 0; i < badges.length; i += 3) {
      final rowItems = badges.skip(i).take(3).toList();

      rows.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowItems.map((badge) {
              return Column(
                children: [
                  Image.asset(
                    badge["image"]!,
                    height: 75, width: 70,
                  ),
                  SizedBox(height: 8),
                  Text(
                    badge["title"]!,
                    style: CustomTextStyles.semiBold(fontSize: 12),
                  ),

                  if (badge["subTitle"] != null && badge["subTitle"]!.isNotEmpty)
                    Text(
                      badge['subTitle']!,
                      style: CustomTextStyles.regular(fontSize: 12),
                    )
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

}
