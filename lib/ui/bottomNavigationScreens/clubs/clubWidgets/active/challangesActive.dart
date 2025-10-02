import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallangesActiveScreen extends StatefulWidget {
  const ChallangesActiveScreen({super.key});

  @override
  State<ChallangesActiveScreen> createState() => _ChallangesActiveScreenState();
}

class _ChallangesActiveScreenState extends State<ChallangesActiveScreen> {
  bool isjoinChallenges = false;
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
    return  Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          Stack(
            children: [
           if(isjoinChallenges == false)   Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage(AppImageOthers.chalBanner),
                    fit: BoxFit.cover,
                  ),
                ),
              )
           else Container(
             height: 220,
             width: double.infinity,
             decoration: const BoxDecoration(
               image: DecorationImage(
                 image:  AssetImage(AppImageOthers.challengesDetailBanner),
                 fit: BoxFit.cover,
               ),
             ),
           ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                left: 15,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 30,
                        child: Image.asset(AppImageOthers.backArrow),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("Challenges",style: CustomTextStyles.bold(textColor: Colors.white,fontSize: 14),)

                  ],
                ),
              )
              ,
              Positioned(
                top: 40,
                right: 15,
                child: Row(
                  children: [
                    SizedBox(
                        height: 30,
                        child: Image.asset(AppImageOthers.notificationIcon)),
                    SizedBox(width: 8),
                    SizedBox(
                        height: 30,
                        child: Image.asset(AppImageOthers.shareIcon)),


                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  child: Image.asset(AppImageOthers.challengesLogo),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
            child: Column(
              children: [
                Text(
                  "December 5k",
                  style:  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "From first attempts to PRs, chase your\nbest 5K run with Brooks.",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textBackgroundGrey
                  ),
                ),
                SizedBox(height: 30),
                if(isjoinChallenges == false)
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bgRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isjoinChallenges = true;
                        });
                      },
                      child: Text(
                        "Join Challenges",
                        style: CustomTextStyles.semiBold(
                            fontSize: 14, textColor: Colors.white),
                      ),
                    ),
                  ),
                ),
                 if(isjoinChallenges==true)
                   Container(
                   margin: EdgeInsets.symmetric(vertical: 5),
                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),

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
                 ),


                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    SizedBox(height: 30,child: Image.asset(AppImageOthers.calenderImg)),
                    SizedBox(width: 5),
                    Text(
                      textAlign: TextAlign.start,
                      "Aug 1, 2025 to Aug 31, 2025 — 1 day left",
                      style: CustomTextStyles.semiBold(
                          fontSize: 12, textColor: AppColor.textBackgroundGrey),maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SvgPicture.asset(AppImageSvg.run,color: Colors.black,width: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          "Complete a 5 km (3.1 mi) run.",
                          style: CustomTextStyles.semiBold(
                              fontSize: 12, textColor: AppColor.textBackgroundGrey),
                        ),
                        Text(
                          textAlign: TextAlign.start,
                          "Qualifying Activities: Run, VirtualRun, \nWheelchair",
                          style: CustomTextStyles.semiBold(
                              fontSize: 12, textColor: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )   ,
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 30,child: Image.asset(AppImageOthers.trophyImg)),
                    Text(
                      textAlign: TextAlign.start,
                      "Earn a digital finisher's badge for your\nTrophy Case.",
                      style: CustomTextStyles.semiBold(
                          fontSize: 12, textColor: AppColor.textBackgroundGrey),maxLines: 2,
                    ),
                  ],
                )

              ],
            ),
          ),
          Spacer(),
if(isjoinChallenges==true)
          Center(
            child: SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.bgRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // join club action
                },
                child: Text(
                  "Invites Friends",
                  style: CustomTextStyles.semiBold(
                      fontSize: 14, textColor: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }




}
