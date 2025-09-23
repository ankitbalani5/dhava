import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/challenges/challangesDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../resources/style/textStyle.dart';
import '../../../../../resources/color/appColor.dart';

class challengesWidget extends StatefulWidget {
  const challengesWidget({Key? key}) : super(key: key);

  @override
  _challengesWidgetState createState() => _challengesWidgetState();
}

class _challengesWidgetState extends State<challengesWidget> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('all', 'All', null),
                  SizedBox(width: 5,),
                  _buildFilterButton('walk', 'Walk', AppImageSvg.walk),
                  SizedBox(width: 5,),
                  _buildFilterButton('run', 'Run', AppImageSvg.run),
                  SizedBox(width: 5,),
                  _buildFilterButton('cycle', 'Cycle', AppImageSvg.cycle),
                ],
              ),
            ),
            SizedBox(height: 20),
            Image.asset(AppImageOthers.challengesBanner,fit: BoxFit.cover,),
            Text('Recommended For You', style: CustomTextStyles.bold(fontSize: 18)),
            Text(
              'Based on your activities',
              style: CustomTextStyles.regular(fontSize: 11, textColor: Colors.grey),
            ),
            SizedBox(height: 20),
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 220,
              ),
              itemCount: 4, // add count
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    width: 250,
                    padding:  EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient:  LinearGradient(
                        colors: [Color(0xFF8993FF).withAlpha(80), Color(0xFFFFFF).withAlpha(2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "July Run 100K Challenge",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                         SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppImageSvg.run,color: Colors.black,
                            ),
                             SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Run a total of 100 km (62.1 mi) in a month.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    "Jul 1 to Jul 31, 2025",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 8),
                        Spacer(),
                        SizedBox(
                          height: 35,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.bgRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:  EdgeInsets.symmetric(vertical: 2),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesDetailScreen()));
                            },
                            child:  Text(
                              "Join Now",
                              style: CustomTextStyles.bold(textColor: Colors.white,
                                  fontSize:
                                  13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


            // बाकी तुम्हारा code
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String type, String text, String? iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filter = type;
        });
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(
              color: filter == type ? AppColor.bgRed : Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                height: 20,
                color: filter == type ? AppColor.bgRed : Colors.black,
              ),
            if (iconPath != null) const SizedBox(width: 5),
            Text(
              text,
              style: CustomTextStyles.regular(
                fontSize: 10,
                textColor: filter == type ? AppColor.bgRed : Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(
              AppImageSvg.cancel,
              color: filter == type ? AppColor.bgRed : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}


