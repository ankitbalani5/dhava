import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tab/diet/dietDetailScreen.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/tips/tipsCardWidget.dart';
import 'package:flutter/material.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  List<Map<String, dynamic>> tipsList = [];

  @override
  void initState() {
    super.initState();

    tipsList = [
      {
        "image": AppImageOthers.dietBanner1,
        "dietitian": "Mediterranean Balance Plan",
        "subtitle": "United States Coach",
        "type": "Diet",
        "name": "Dietitian Jeff",
        "description":
        "A heart-healthy diet inspired by Mediterranean countries, emphasizing fresh vegetables, fruits, olive oil, whole grains, and lean proteins.",
        "duration": "16-20 weeks",
        "frequency": "3 days/week",
        "followDiet": "Include colorful salads, whole grains like quinoa or brown rice, grilled fish or chicken, and olive oil as the main fat source. Avoid processed foods and excess sugar. Drink plenty of water and enjoy moderate red wine if preferred.",
        "keyFeatures": [
          "Focuses on fresh, natural ingredients",
          "Improves heart health and energy levels",
          "Encourages mindful, portion-controlled eating",
          "Includes weekly recipe updates"
        ]
      },
      {
        "image": AppImageOthers.dietBanner2,
        "dietitian": "Plant Power Diet",
        "subtitle": "India Coach",
        "type": "Diet",
        "name": "Nutritionist Priya Sharma",
        "description":
        "A plant-based plan designed to detoxify the body and enhance vitality through fruits, vegetables, legumes, and whole grains.",
        "duration": "12–18 weeks",
        "frequency": "5 days/week",
        "followDiet": "Eliminate all meat, eggs, and dairy. Include lentils, beans, leafy greens, seeds, and nuts daily. Drink green smoothies and stay hydrated throughout the day. Focus on natural, unprocessed plant foods.",
        "keyFeatures": [
          "100% vegan and high in fiber",
          "Enhances energy and improves digestion",
          "Supports clear skin and better metabolism",
          "Includes meal reminders and grocery lists"
        ]
      },
      {
        "image": AppImageOthers.dietBanner3,
        "dietitian": "High-Protein Lean Diet",
        "subtitle": "United Kingdom Coach",
        "type": "Diet",
        "name": "Coach Michael Davis",
        "description":
        "A structured diet focusing on high-quality protein intake to support lean muscle gain and faster recovery.",
        "duration": "10–16 weeks",
        "frequency": "6 days/week",
        "followDiet": "Consume eggs, chicken breast, paneer, lentils, tofu, and protein smoothies daily. Avoid sugary snacks and fried foods. Combine diet with regular resistance or strength training for best results.",
        "keyFeatures": [
          "Boosts metabolism and supports muscle gain",
          "Reduces unwanted fat effectively",
          "Promotes faster post-workout recovery",
          "Includes daily protein tracking tips"
        ]
      },
      {
        "image": AppImageOthers.dietBanner4,
        "dietitian": "Low-Carb Smart Diet",
        "subtitle": "Spain Coach",
        "type": "Diet",
        "name": "Dietitian Sofia Hernández",
        "description":
        "A controlled carbohydrate plan designed to balance blood sugar, reduce cravings, and promote steady weight loss.",
        "duration": "14–20 weeks",
        "frequency": "4 days/week",
        "followDiet": "Reduce carb intake from rice, bread, and sweets. Focus on eggs, lean meats, leafy vegetables, nuts, and low-carb fruits. Drink water regularly and track carb consumption through the app.",
        "keyFeatures": [
          "Reduces refined carbs and sugar",
          "Boosts metabolism with healthy fats",
          "Improves focus and energy levels",
          "Offers easy low-carb meal guides"
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
                  builder: (context) => DietDetailScreen(
                    imageUrl: item["image"],
                    type: item["type"],
                    dietitian: item["dietitian"],
                    description: item["followDiet"],
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

