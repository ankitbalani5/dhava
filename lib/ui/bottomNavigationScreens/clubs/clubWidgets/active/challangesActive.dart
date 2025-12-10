import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../bloc/challengeDetailBloc/challenge_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';



class ChallangesActiveScreen extends StatefulWidget {
  final String challengeId;
  ChallangesActiveScreen({required this.challengeId, super.key});

  @override
  State<ChallangesActiveScreen> createState() => _ChallangesActiveScreenState();
}

class _ChallangesActiveScreenState extends State<ChallangesActiveScreen> {

  double _progress = 0.4;
  double _oldProgress = 0.0;


  void updateProgress(double newValue) {
    setState(() {
      _oldProgress = _progress;
      _progress = newValue;
    });
  }

  @override
  void initState() {
    context.read<ChallengeDetailBloc>().add(ChallengeDetailEvent(context: context, challengeId: widget.challengeId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ChallengeDetailBloc, ChallengeDetailState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is ChallengeDetailLoading){
            return Constant.loadingAnimation();
          }
          if(state is ChallengeDetailSuccess){
            var challengeDetail = state.challengeDetailModel.data;
            var isJoined = challengeDetail?.isJoined;
            final duration = Constant.calculateChallengeDuration(
              challengeDetail!.startDate,
              challengeDetail.endDate,
            );
            var startDate = DateTime.parse(challengeDetail.startDate ?? '');
            var endDate = DateTime.parse(challengeDetail.endDate ?? '');
            double _progress = Constant.calculateProgress(startDate, endDate);
            print(challengeDetail);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      if(isJoined == false)   Container(
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
                      // Positioned(
                      //   top: 40,
                      //   right: 15,
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //           height: 30,
                      //           child: Image.asset(AppImageOthers.notificationIcon)),
                      //       SizedBox(width: 8),
                      //       SizedBox(
                      //           height: 30,
                      //           child: Image.asset(AppImageOthers.shareIcon)),
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ClipOval(
                            child: Image.network(
                              challengeDetail!.trophyIcon.toString(),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              
                    ],
                  ),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          challengeDetail!.title.toString(),
                          style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(challengeDetail.description.toString(),
                          // "From first attempts to PRs, chase your\nbest 5K run with Brooks.",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textBackgroundGrey
                          ),
                        ),
                        SizedBox(height: 30),
                        if(isJoined == false)
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
                                    challengeDetail.isJoined = true;
                                    context.read<ChallengeDetailBloc>().add(ChallengeDetailEvent(context: context, challengeId: widget.challengeId));
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
                        if(isJoined==true)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              
                            child: Row(
                              children: [
              
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: challengeDetail.challengeIcon ?? '',
                                      width: 51.0,
                                      height: 51.0,
                                      fit: BoxFit.fill,
                                      placeholder:
                                          (context, url) =>
                                          Padding(
                                            padding:
                                            EdgeInsets.all(
                                                40.0),
                                            child:
                                            CircularProgressIndicator(
                                              color: AppColor.bgRed,
                                              strokeWidth: 1,
                                            ),
                                          ),
                                      errorWidget: (context,
                                          url, error) =>
                                          SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
                                    )
                                ),
                                // SvgPicture.asset(AppImageSvg.activeUser, height: 51,),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 210,
                                          child: Text(challengeDetail.title ?? ''/*'Timeout Streaks Challenge July 2025'*/, style: CustomTextStyles.semiBold(fontSize: 16),)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: challengeDetail.categoryIcon ?? '',
                                                width: 15.0,
                                                height: 15.0, color: Colors.grey,
                                                fit: BoxFit.fill,
                                                placeholder:
                                                    (context, url) =>
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          40.0),
                                                      child:
                                                      CircularProgressIndicator(
                                                        color: AppColor.bgRed,
                                                        strokeWidth: 1,
                                                      ),
                                                    ),
                                                errorWidget: (context,
                                                    url, error) =>
                                                    SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                                              ),
                                              // SvgPicture.asset(AppImageSvg.run, color: Colors.grey,),
                                              Text('--/${duration['weeks']} weeks', style: CustomTextStyles.regular(
                                                  fontSize: 11, textColor: Colors.grey),),
                                            ],
                                          ),
                                          Text('${duration['daysLeft']} days left', style: CustomTextStyles.regular(
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(),
                            SizedBox(height: 30,child: Image.asset(AppImageOthers.calenderImg)),
                            SizedBox(width: 15,),
                            Text(formatDateRange(challengeDetail.startDate.toString(), challengeDetail.endDate.toString()),
                              textAlign: TextAlign.start,
                              // "Aug 1, 2025 to Aug 31, 2025 — 1 day left",
                              style: CustomTextStyles.semiBold(
                                  fontSize: 12, textColor: AppColor.textBackgroundGrey),maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
              
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.network(challengeDetail.categoryIcon.toString(), color: Colors.black, width: 30,),
                            SizedBox(width: 15,),
                            // SvgPicture.asset(AppImageSvg.run,color: Colors.black,width: 30,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*.75,
                                  child: Text(challengeDetail.title.toString(),
                                    textAlign: TextAlign.start,
                                    // "Complete a 5 km (3.1 mi) run.",
                                    style: CustomTextStyles.semiBold(
                                        fontSize: 12, textColor: AppColor.textBackgroundGrey),
                                  ),
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 30,child: Image.asset(AppImageOthers.trophyImg)),
                            SizedBox(width: 15,),
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
                  SizedBox(height: 50,)
                ],
              ),
            );
          }
          if(state is ChallengeDetailError){
            return Center(
              child: Text(state.error),
            );
          }
          return SizedBox();
        },
      ),
    );
  }


  String formatDateRange(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime now = DateTime.now();

    // Format dates like "Aug 1, 2025"
    String formattedStart = DateFormat("MMM d, yyyy").format(start);
    String formattedEnd = DateFormat("MMM d, yyyy").format(end);

    // Calculate days left
    int daysLeft = end.difference(now).inDays;

    String daysLeftText = "";
    if (daysLeft > 0) {
      daysLeftText = "$daysLeft day${daysLeft > 1 ? 's' : ''} left";
    } else if (daysLeft == 0) {
      daysLeftText = "Today";
    } else {
      daysLeftText = "Ended ${daysLeft.abs()} day${daysLeft.abs() > 1 ? 's' : ''} ago";
    }

    return "$formattedStart to $formattedEnd — $daysLeftText";
  }


}
