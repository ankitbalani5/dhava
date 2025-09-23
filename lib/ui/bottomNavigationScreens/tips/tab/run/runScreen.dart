import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/run/runDetailScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tipsCardWidget.dart';
import 'package:flutter/material.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  List<Map<String, dynamic>> tipsList = [];

  @override
  void initState() {
    super.initState();

    tipsList = [
      {
        "image": AppImageOthers.runBanner,
        "name": "Jeff Galloway",
        "subtitle": "Garmin Coach",
        "type": "Run",
        "dietitian": "Dietitian Jeff",
        "description":
        "Coach Jeff Galloway's methods help beginners start running with walk breaks to control fatigue.",
        "duration": "16-20 weeks",
        "frequency": "3 days/week",
        "keyFeatures": [
          "Workouts adapt based on benchmark runs",
          "Additional coaching videos and articles",
          "Nutrition guidance and support"
        ]
      },
      {
        "image": AppImageOthers.runBanner,
        "name": "Jeff Galloway",
        "subtitle": "Garmin Coach",
        "type": "Run",
        "dietitian": "Dietitian Jeff",
        "description":
        "Coach Jeff Galloway's training focuses on endurance and performance with structured plans.",
        "duration": "12 weeks",
        "frequency": "4 days/week",
        "keyFeatures": [
          "Structured weekly schedules",
          "Performance tracking",
          "Additional coaching videos and articles"
        ]
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tipsList.length,
        itemBuilder: (context, index) {
          final item = tipsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RunDetailScreen(
                    imageUrl: item["image"],
                    type: item["type"],
                    dietitian: item["dietitian"],
                    description: item["description"],
                    keyFeatures: List<String>.from(item["keyFeatures"]),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TipsCard(
                imageUrl: item["image"],
                name: item["name"],
                subtitle: item["subtitle"],
                type: item["type"],
                dietitian: item["dietitian"],
                description: item["description"],
                duration: item["duration"],
                frequency: item["frequency"],
              ),
            ),
          );
        },
      ),
    );
  }
}
