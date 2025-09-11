import 'package:flutter/material.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final List<Map<String, dynamic>> newsList = [
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": "2 Mins Ago",
      "image": "https://picsum.photos/400/200?1", // dummy image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": null,
      "image": null, // no image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": null,
      "image": null, // no image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": "10 Mins Ago",
      "image": "https://picsum.photos/400/200?2",
    },
    // {
    //   "title": "Start Your Healthy Life Today!",
    //   "description":
    //   "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! "
    //       "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
    //   "time": "15 Mins Ago",
    //   "image": null,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackButtonWidget()),
        title: Text('News', style: CustomTextStyles.bold()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// अगर image है तो show करो
                if (news["image"] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      news["image"],
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),

                /// Title + Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(news["title"],
                            style: CustomTextStyles.bold(fontSize: 12))),
                    if (news["time"] != null)
                      Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Text(news["time"],
                            style: CustomTextStyles.medium(
                                fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                /// Description
                Text(news["description"],
                    style: CustomTextStyles.regular(
                        fontSize: 10, textColor: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
