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
        "image": AppImageOthers.runBanner1,
        "name": "Jeff Galloway",
        "subtitle": "United States Coach",
        "type": "Run",
        "dietitian": "FULL MARATHON",
        "description":
        "Jeff Galloway is a former Olympian and internationally known running coach who pioneered the “Run-Walk-Run” training method. His proven techniques help runners of all ages complete marathons safely while minimizing fatigue and injury.",
        "duration": "16-20 weeks",
        "frequency": "3–4 days/week",
        "detail": "Full Marathon training focuses on developing endurance, pacing, and mental strength. Jeff’s plan emphasizes alternating run and walk intervals, gradually increasing mileage each week to build stamina without overtraining. Long runs on weekends and recovery days are key to success.",
        "keyFeatures": [
          "Structured 16–20-week training plan",
          "3–4 runs per week with progressive mileage increase",
          "“Run-Walk-Run” intervals to manage fatigue",
          "Benchmark runs to measure improvement",
          "Weekly recovery guidance to prevent burnout",
          "Coaching videos and articles for motivation and nutrition",
        ]
      },
      {
        "image": AppImageOthers.runBanner2,
        "name": "Maria Gonzalez",
        "subtitle": "Spain Coach",
        "type": "Run",
        "dietitian": "HALF MARATHON",
        "description":
        "Coach Maria Gonzalez is a professional marathon trainer from Spain, known for her focus on performance improvement, speed endurance, and balanced recovery techniques for mid-distance runners.",
        "duration": "12–16 weeks",
        "frequency": "3–4 days/week",
        "detail": "The Half Marathon plan helps runners improve pace, endurance, and confidence over 21.1 km. It combines interval training, tempo runs, and weekly long runs. Maria’s approach ensures runners build the right blend of stamina and speed to finish strong without overexertion.",
        "keyFeatures": [
          "12–16-week customized training plan",
          "3–4 days of running per week",
          "Interval runs for speed and stamina",
          "Hill workouts to strengthen legs and lungs",
          "Recovery sessions to enhance performance consistency",
          "Detailed coaching videos and nutrition tips",
        ]
      },
      {
        "image": AppImageOthers.runBanner3,
        "name": "Jeff Galloway",
        "subtitle": "United States Coach",
        "type": "Run",
        "dietitian": "Build Endurance Smartly",
        "description":
        "Coach Jeff Galloway is a former Olympian and globally recognized running expert known for developing the “Run-Walk-Run” method that helps beginners and pros improve endurance safely.",
        "duration": "16–20 weeks",
        "frequency": "3 days/week",
        "detail": "Start with alternating short intervals of running and walking. Gradually increase running time while reducing walk breaks. This method improves stamina, builds confidence, and minimizes fatigue or injury risk.",
        "keyFeatures": [
          "Gradual increase in endurance levels",
          "Low risk of injury and fatigue",
          "Focused on beginners and returning runners",
          "Personalized pacing guidance",
        ]
      },
      {
        "image": AppImageOthers.runBanner4,
        "name": "Maria Gonzalez",
        "subtitle": "Spain Coach",
        "type": "Run",
        "dietitian": "Speed Training for Progress",
        "description":
        "Coach Maria is an elite marathon trainer specializing in performance improvement through speed, agility, and endurance-focused routines.",
        "duration": "12–16 weeks",
        "frequency": "4 days/week",
        "detail": "Add interval runs — short bursts of high-speed running followed by recovery jogs. Include hill sprints once weekly to strengthen lower body and improve overall speed and stamina.",
        "keyFeatures": [
          "Improves pace and cardiovascular health",
          "Builds leg strength through hill and interval training",
          "Enhances oxygen utilization",
          "Ideal for intermediate and advanced runners",
        ]
      },
      {
        "image": AppImageOthers.runBanner5,
        "name": "Arjun Mehta",
        "subtitle": "India Coach",
        "type": "Run",
        "dietitian": "Mindful Running Technique",
        "description":
        "Coach Arjun emphasizes mindfulness and breathing techniques for efficient running posture and mental focus during long runs.",
        "duration": "10–14 weeks",
        "frequency": "3 days/week",
        "detail": "Maintain a consistent rhythm in your stride and breathing. Focus on staying relaxed, upright, and mentally present. Mindful running helps improve endurance and reduce unnecessary stress.",
        "keyFeatures": [
          "Promotes mindful breathing and focus",
          "Reduces muscle tension and stress",
          "Improves posture and stride efficiency",
          "Suitable for long-distance runners",
        ]
      },
      {
        "image": AppImageOthers.runBanner6,
        "name": "Daniel Peterson",
        "subtitle": "United Kingdom Coach",
        "type": "Run",
        "dietitian": "Recovery Run Routine",
        "description":
        "Coach Daniel is a seasoned endurance trainer focusing on recovery optimization and consistent progress for long-distance athletes.",
        "duration": "8–12 weeks",
        "frequency": "2–3 days/week",
        "detail": "Perform easy-paced runs on recovery days to promote muscle healing and maintain momentum. Keep the effort light and steady to prepare your body for your next intense workout.",
        "keyFeatures": [
          "Aids in muscle recovery and flexibility",
          "Prevents overtraining and burnout",
          "Improves overall running consistency",
          "Ideal between high-intensity workout sessions",
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
