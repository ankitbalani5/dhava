
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/progressHistory.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:flutter/material.dart';

class Endurance extends StatefulWidget {
  const Endurance({super.key});

  @override
  State<Endurance> createState() => _EnduranceState();
}

class _EnduranceState extends State<Endurance> {
  int selectedIndex = 1; // Default: Run

  final List<String> labels = ['Walk', 'Run', 'Cycle'];
  final List<IconData> icons = [
    Icons.directions_walk,
    Icons.directions_run,
    Icons.directions_bike
  ];

  // 🔁 Corresponding images for each mode
  final List<String> backgroundImages = [
    AppImageOthers.walkEndurance, // 👈 create this asset
    AppImageOthers.runEndurance,
    AppImageOthers.cycleEndurance, // 👈 create this asset
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white24),
          child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              )),
        ),
        title: Text(
          'Endurance',
          style: CustomTextStyles.regular(),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.black),

          /// 🔁 Background Image according to selectedIndex
          Positioned(
            top: 50,
            child: Image.asset(
              backgroundImages[selectedIndex],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

          /// Gradient overlay
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Activity Selector Buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected ? AppColor.bgRed : Colors.white24,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                            isSelected ? Colors.transparent : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(icons[index], size: 20),
                    label: Text(labels[index]),
                  ),
                );
              }),
            ),
          ),

          /// Bottom Text and Button
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text('Get Started With Your\nHealth Goals',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.semiBold(fontSize: 26)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressScreen()));
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: Text('Start', style: CustomTextStyles.bold()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bgRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
