import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class KudosScreen extends StatefulWidget {
  const KudosScreen({super.key});

  @override
  State<KudosScreen> createState() => _KudosScreenState();
}

class _KudosScreenState extends State<KudosScreen> {
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
        title: Text('Kudos', style: CustomTextStyles.bold(),),
      ),
      body: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        color: AppColor.bgTile,
        child: Center(child: Text('This activity currently does not have any kudos',
          style: CustomTextStyles.regular(fontSize: 14),)
        ),
      ),
    );
  }
}
