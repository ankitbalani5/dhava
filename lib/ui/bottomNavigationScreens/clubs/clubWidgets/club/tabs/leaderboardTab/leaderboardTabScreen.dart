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

            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: AppColor.bgRed,
                        decoration: InputDecoration(
                          hintText: "Search athelete...",
                          // prefixIcon: const Icon(Icons.search),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: SvgPicture.asset(AppImageSvg.searchRed, height: 33,),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,  // इसको adjust करके perfect center पा सकते हैं
                            horizontal: 10,
                          ),
                          /*IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward, color: Colors.red),
                      ),*/
                          filled: true,
                          fillColor: AppColor.bgTextField,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                      onTap: () {
                        _showFilterPopup(context);
                      },
                      child: Image.asset(AppImageOthers.filterWeRunner, width: 33,))
                ],
              ),
            ),


            ListView.builder(
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        flex: 5,
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

void _showFilterPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.only(right: 20, top: 120),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 200,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.filter_list, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "Filter",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),

              Divider(),

              // Options List
              ..._filterOptions.map((item) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item,
                            style: TextStyle(
                                fontSize: 14,
                                color: item == "All" ? Colors.red : Colors.black)),
                        if (item == "All")
                          Icon(Icons.check, color: Colors.red, size: 18),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}

List<String> _filterOptions = [
  "All",
  "Male",
  "Female",
  "Under 15",
  "15-25",
  "25-35",
  "35-45",
  "45-55",
  "55-65",
  "65-Above",
];


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
