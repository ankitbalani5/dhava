import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createClub/clubTypeStep.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createClub/customStep.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createClub/locationStep.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createClub/privacyStep.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createClub/sportStep.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class ClubModel {
  String? sport;
  String? type;
  String? clubName;
  String? description;
  bool isPublic = true;
  String? location;
}
class CreateAClub extends StatefulWidget {
  const CreateAClub({super.key});

  @override
  State<CreateAClub> createState() => _CreateAClubState();
}

class _CreateAClubState extends State<CreateAClub> {

  final PageController _pageController = PageController();
  int currentStep = 0;
  final ClubModel club = ClubModel();


  void _nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
      _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

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
        title: Text(getTitle(currentStep), style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
        child: Column(
          children: [

            SizedBox(width:double.infinity,child: LinearProgressIndicator(color: AppColor.bgRed,backgroundColor: AppColor.bgRed.withAlpha(20),value: (currentStep + 1) / 5)),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SportStep(onNext: _nextStep, club: club),
                  ClubTypeStep(onNext: _nextStep, club: club),
                  CustomizeStep(onNext: _nextStep, club: club),
                  PrivacyStep(onNext: _nextStep, club: club),
                  LocationStep(club: club),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTitle(int currentStep) {
    switch (currentStep) {
      case 0:
        return "Sport";
      case 1:
        return "Club Type";
      case 2:
        return "Club Type";
      case 3:
        return "Sport";
      case 4:
        return "Sport";
      default:
        return "";
    }
  }


}
