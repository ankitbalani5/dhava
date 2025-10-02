
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/active/challangesActive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActiveWidget extends StatefulWidget {
  const ActiveWidget({Key? key}) : super(key: key);

  @override
  _ActiveWidgetState createState() => _ActiveWidgetState();
}

class _ActiveWidgetState extends State<ActiveWidget> {
  String filter = 'all';
  double _progress = 0.4;
  double _oldProgress = 0.0;


  void updateProgress(double newValue) {
    setState(() {
      _oldProgress = _progress;
      _progress = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
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

                // बाकी तुम्हारा code
              ],
            ),
          ),


          SizedBox(height: 20,),
          Stack(
            children: [
              Image.asset(AppImageOthers.activeBanner),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('This Year', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),
                          Text('1', style: CustomTextStyles.regular(fontSize: 16,textColor: Colors.white)),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('All Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                          Text('39', style: CustomTextStyles.regular(fontSize: 16,textColor: Colors.white)),
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChallangesActiveScreen()));
                },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 210,
                                  child: Text('Timeout Streaks Challenge July 2025', style: CustomTextStyles.semiBold(fontSize: 16),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                                      Text('--/4 weeks', style: CustomTextStyles.regular(
                                          fontSize: 11, textColor: Colors.grey),),
                                    ],
                                  ),
                                  Text('10 days left', style: CustomTextStyles.regular(
                                      fontSize: 11, textColor: Colors.grey),),

                                ],
                              ),
                              SizedBox(height:10,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                      begin: _oldProgress, end: _progress),
                                  duration: Duration(milliseconds: 500),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                        value: value,
                                        minHeight: 8,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.grey),
                                      ),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },),
            ),
          )
        ],
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

