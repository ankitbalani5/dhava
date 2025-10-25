import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/cycle/cycleDetailScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tipsCardWidget.dart';
import 'package:flutter/material.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  List<Map<String, dynamic>> tipsList = [];

  @override
  void initState() {
    super.initState();

    tipsList = [
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Hill Climb Strength Plan",
        "subtitle": "United Kingdom Coach",
        "type": "Cycle",
        "name": "Daniel Brooks",
        "description":
        "Daniel Brooks is a British cycling coach and former mountain racer with a decade of experience in hill endurance training. His coaching emphasizes strength building, power management, and gear-shifting techniques for elevation gain.",
        "duration": "8–10 weeks",
        "frequency": "3 days/week",
        "detail": "This plan focuses on conquering climbs through proper pacing and breathing control. You’ll learn how to use gears effectively, maintain consistent cadence, and distribute energy evenly during long ascents.",
        "keyFeatures": [
          "8–10-week program | 3 days/week",
          "Focus on uphill stamina and muscular power",
          "Strength and core workouts off the bike",
          "Gear-shifting and gradient-handling drills",
          "Endurance tests at mid and final phases",
        ]
      },
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Speed Interval Program",
        "subtitle": "Spain Coach",
        "type": "Cycle",
        "name": "Maria Gonzalez",
        "description":
        "Maria Gonzalez is a performance cycling coach from Spain specializing in sprint and track cycling. She has trained national-level athletes to improve short-distance speed and cadence rhythm.",
        "duration": "6–8 weeks",
        "frequency": "4 days/week",
        "detail": "The Speed Interval Program enhances your cardiovascular capacity and reaction power through structured short sprints and active recovery periods.",
        "keyFeatures": [
          "6–8-week plan | 4 days/week",
          "High-intensity sprint and recovery sessions",
          "Cadence and gear coordination focus",
          "VO2 max improvement drills",
          "Weekly performance tracking",
        ]
      },
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Endurance Foundation Plan",
        "subtitle": "Singapore Coach",
        "type": "Cycle",
        "name": "Victor Lee",
        "description":
        "Victor Lee is a long-distance cycling expert known for training endurance athletes for events like Gran Fondos and Tour rides.",
        "duration": "12–16 weeks",
        "frequency": "4 days/week",
        "detail": "This plan builds a solid aerobic base for long-distance riders. You’ll progressively increase ride durations and enhance your ability to sustain energy over hours of cycling.",
        "keyFeatures": [
          "12–16-week plan | 4 days/week",
          "Focus on zone-2 endurance training",
          "Long weekend rides",
          "Nutrition and hydration guidance",
          "Weekly stamina checkpoints",
        ]
      },
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Recovery Ride Routine",
        "subtitle": "Denmark Coach",
        "type": "Cycle",
        "name": "Sarah Jensen",
        "description":
        "Sarah Jensen is a certified recovery and rehabilitation specialist who trains cyclists on post-ride recovery, flexibility, and muscle repair.",
        "duration": "4–6 weeks",
        "frequency": "2–3 days/week",
        "detail": "The Recovery Ride Routine is designed to reduce fatigue, improve blood circulation, and prepare your body for the next training day.",
        "keyFeatures": [
          "4–6-week program | 2–3 days/week",
          "Light spinning and stretching sessions",
          "Focus on heart-rate recovery and oxygen flow",
          "Post-ride nutrition tips",
          "Mindful breathing techniques",
        ]
      },
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Core Stability & Balance Plan",
        "subtitle": "Brazil Coach",
        "type": "Cycle",
        "name": "Andre Silva",
        "description":
        "Andre Silva is a Brazilian sports physiologist specializing in improving cyclists’ posture and stability to maximize performance and prevent injuries.",
        "duration": "6–10 weeks",
        "frequency": "3 days/week",
        "detail": "This plan strengthens your core and improves balance for better control and endurance during long rides or uneven terrains.",
        "keyFeatures": [
          "6–10-week program | 3 days/week",
          "Core activation and balance drills",
          "Indoor stability exercises",
          "Resistance training for posture",
          "Injury prevention and flexibility tips",
        ]
      },
      {
        "image": AppImageOthers.cycleBanner,
        "dietitian": "Morning Fresh Ride Plan",
        "subtitle": "Australia Coach",
        "type": "Cycle",
        "name": "Emily Carter",
        "description":
        "Emily Carter is an Australian lifestyle cycling coach known for creating energizing early-morning routines that boost metabolism and mental clarity.",
        "detail": "This plan focuses on energizing morning rides to improve alertness, metabolism, and consistency in your cycling habit.",
        "duration": "6 weeks",
        "frequency": "3–4 days/week",
        "keyFeatures": [
          "6-week plan | 3–4 days/week",
          "Short morning cardio rides",
          "Focus on breathing and mindfulness",
          "Fat-burn optimization",
          "Hydration and pre-ride nutrition tips",
        ]
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tipsList.length,
        itemBuilder: (context, index) {
          final item = tipsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CycleDetailScreen(
                    imageUrl: item["image"],
                    type: item["type"],
                    dietitian: item["dietitian"],
                    description: item["detail"],
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
