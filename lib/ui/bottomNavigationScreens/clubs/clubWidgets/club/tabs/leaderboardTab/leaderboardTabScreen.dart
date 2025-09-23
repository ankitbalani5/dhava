import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:flutter/material.dart';

class LeaderboardTabScreen extends StatelessWidget {
  const LeaderboardTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              height: 80,
              color: AppColor.bgRed,
              padding:  EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children:  [
                  Text(
                    "8,567",
                    style: TextStyle(
                      fontSize:26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Total Club Kilometers",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  _statRow("Activities", "757"),
                  _statRow("Leading Distance", "124 Km"),
                  _statRow("Leading Time", "23h41m"),

                  Text(
                    "Your Activities",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _statRow("Distance", "0 km"),
                  _statRow("Time", "0 h"),
                ],
              ),
            ),
             Divider(height: 1, color: Colors.black12),
            Container(
              padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.grey.shade100,
              child: const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "RANK",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "ATHLETE",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "DISTANCE",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),


            ListView.builder(
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration:  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("${index + 1}"),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            SizedBox(height: 30,child: Image.asset(AppImageOthers.defaultUserImg)),
                             SizedBox(width: 8),
                             Text(
                              "Rajiv Malik",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                       Expanded(
                        flex: 2,
                        child: Text(
                          "153.72 km",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _statRow extends StatelessWidget {
  final String title;
  final String value;

  const _statRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:  TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value,
              style:  TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
