import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/cycle/cycleScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/diet/dietScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/run/runScreen.dart';
import 'package:coherent_endurance/ui/notification/notificationScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TipScreen extends StatefulWidget {
  final String? initialTab;
  const TipScreen({super.key, this.initialTab});

  @override
  State<TipScreen> createState() => _TipscreenState();
}

class _TipscreenState extends State<TipScreen> {
  final List<String> labels = ['Diet', 'Run', 'Cycle'];
  final List<String> keys = ['diet', 'run', 'cycle'];
  final List<String> icons = [
    AppImageSvg.diet,
    AppImageSvg.run,
    AppImageSvg.cycle
  ];

  String tabStatus = 'diet';

  @override
  void initState() {
    super.initState();
    tabStatus = widget.initialTab ?? 'diet';
  }

  Widget buildTabButton({
    required String label,
    required String icon,
    required String key,
  }) {
    final bool isSelected = tabStatus == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          tabStatus = key;
        });
      },
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColor.bgRed : AppColor.bgTile,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 20,
              width: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
             SizedBox(width: 8),
            Text(
              label,
              style: CustomTextStyles.medium(
                fontSize: 16,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userName = '${context.read<ProfileBloc>().profileModel!.data!.firstName} ${context.read<ProfileBloc>().profileModel!.data!.lastName}';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning', style: CustomTextStyles.regular()),
            Text(userName, style: CustomTextStyles.bold()),
          ],
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  NotificationScreen(),
                  ),
                );
              },
              child: SvgPicture.asset(
                AppImageSvg.notification,
                width: 30,
                height: 30,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTabButton(label: "Diet", icon: icons[0], key: keys[0]),
                 SizedBox(width: 10),
                buildTabButton(label: "Run", icon: icons[1], key: keys[1]),
                 SizedBox(width: 10),
                buildTabButton(label: "Cycle", icon: icons[2], key: keys[2]),
              ],
            ),
            SizedBox(height: 10,),
        
            /// --- Tab Content ---
            Expanded(
              child: Builder(
                builder: (context) {
                  if (tabStatus == 'diet') return  DietScreen();
                  if (tabStatus == 'run') return  RunScreen();
                  if (tabStatus == 'cycle') return  CycleScreen();
                  return  SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
