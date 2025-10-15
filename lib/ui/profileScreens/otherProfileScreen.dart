import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_event.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_state.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_bloc.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_state.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_bloc.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/allChallenges/userAllChallenges.dart';
import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/statisticsScreen.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/ui/trophyCase.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/suggestionBloc/suggestion_event.dart';
import 'activitiesScreen.dart';
import 'editProfileScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OtherProfileScreen extends StatefulWidget {
  final String userId;

  OtherProfileScreen({this.userId = 'user', super.key});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  List<Map<String, String>> milestone = [
    {"image": AppImageOthers.milestone, "title": "December 5K"},
    {"image": AppImageOthers.milestone, "title": "December 5K"},
    {"image": AppImageOthers.milestone, "title": "December 5K"},
  ];

  @override
  void initState() {
    var userId = widget.userId;
    context.read<OtherProfileBloc>().add(
      OtherProfileDataEvent(context: context, userId: userId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OtherProfileBloc, OtherProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OtherProfileLoading) {
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: AppColor.bgRed,
                size: 20,
              ),
            );
          }
          if (state is OtherProfileSuccess) {
            var profileData = state.otherProfileModel.data;
            var photoUrl = profileData?.profilePhoto ?? "N/A";
            var firstName = profileData?.firstName ?? "N/A";
            var lastName = profileData?.lastName ?? "N/A";
            var bio = profileData?.bio ?? "N/A";
            var address = profileData?.address ?? "N/A";
            var city = profileData?.city ?? "N/A";
            var country = profileData?.country ?? "N/A";
            var stateName = profileData?.state ?? "N/A";
            var totalFollowers = profileData?.totalFollowers ?? "";
            var totalFollowing = profileData?.totalFollowing ?? "";

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Image.asset(AppImageOthers.user),
                      Container(height: 210),
                      Container(
                        color: AppColor.bgRed,
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      height: 55,
                                      width: 55,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: BackButtonWidget(
                                          arrowColor: Colors.black,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10),
                                    // Text('Profile', style: CustomTextStyles.bold(fontSize: 18),)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      widget.userId == 'user'
                                          ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  SearchScreen(),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/image/others/profileSearch.png',
                                          height: 28,
                                        ),
                                      )
                                          : SizedBox(),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                        },
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      widget.userId == 'user'
                                          ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  SettingScreen(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                        ),
                                      )
                                          : IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                        onPressed:
                                            () =>
                                            _showCupertinoMenu(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 20,
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              color: AppColor.bgRed,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 1,
                                    ), // 🔴 red border
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: photoUrl.toString(),
                                      width: 90.0,
                                      height: 90.0,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Padding(
                                        padding: EdgeInsets.all(40.0),
                                        child: CircularProgressIndicator(
                                          color: AppColor.bgRed,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                      errorWidget:
                                          (context, url, error) => Image.asset(
                                        AppImageOthers.profilePic,
                                        height: 90,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(height: 60, color: AppColor.bgRed),
                      ),
                      widget.userId == 'user'
                          ? Positioned(
                        right: 15,
                        bottom: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.bgRed,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          : SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Text(
                          '${firstName ?? 'User'} ${lastName ?? ''}',
                          style: CustomTextStyles.bold(fontSize: 26),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              '${city ?? ''} ${stateName ?? ''}'
                                  ' ${country ?? ''}',
                              style: CustomTextStyles.medium(fontSize: 17),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          bio ?? 'No Bio',
                          style: TextStyle(
                            fontSize: 11 /*, color: Colors.grey,*/,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                totalFollowers.toString(),
                                style: CustomTextStyles.bold(
                                  fontSize: 14,
                                  textColor: Colors.black,
                                ),
                              ),
                              Text(
                                'Follower',
                                style: CustomTextStyles.regular(
                                  fontSize: 10,
                                  textColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      SvgPicture.asset(AppImageSvg.verticalLine),
                      SizedBox(width: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                totalFollowing.toString(),
                                style: CustomTextStyles.bold(
                                  fontSize: 14,
                                  textColor: Colors.black,
                                ),
                              ),
                              Text(
                                'Following',
                                style: CustomTextStyles.regular(
                                  fontSize: 10,
                                  textColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  BlocConsumer<FollowRequestBloc, FollowRequestState>(
                    listener: (context, state) {
                      if (state is FollowRequestLoading) {
                        debugPrint("FollowRequest: Loading...");
                      }

                      if (state is FollowRequestSuccess) {
                        context.read<SuggestionBloc>().add(GetSuggestionEvent(perPage: '10', page: '1', context: context));
                        // var message = state.followRequestModel.message.toString();
                      }

                      if (state is FollowRequestError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      Color buttonColor;
                      Color textColor;
                      String buttonText;

                      //  --- FOLLOWING ---
                      if (profileData?.isFollowed == true && profileData?.isFollowRequested == false) {
                        buttonColor = Colors.green;
                        textColor = Colors.white;
                        buttonText = "Following";

                        return GestureDetector(
                          onTap: () {
                            var userId = profileData?.userId.toString() ?? "";
                            showUnfollowDialog(context, userId, profileData!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: buttonColor,
                              ),
                              child: Center(
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      //  --- REQUESTED ---
                      if (profileData?.isFollowRequested == true) {
                        buttonColor = Colors.grey;
                        textColor = Colors.white;
                        buttonText = "Requested";

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              profileData?.isFollowRequested = false;
                            });
                            context.read<FollowRequestBloc>().add(
                              FollowRequestDataEvent(
                                context: context,
                                toUserId: profileData?.userId ?? "",
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: buttonColor,
                              ),
                              child: Center(
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // 🟩 --- FOLLOW ---
                      buttonColor = AppColor.bgRed;
                      textColor = Colors.white;
                      buttonText = "Follow";

                      return GestureDetector(
                        onTap: () {
                          if (profileData?.isFollowed == false &&
                              profileData?.isFollowRequested == false) {
                            setState(() {
                              profileData?.isFollowRequested = true;
                            });
                            context.read<FollowRequestBloc>().add(
                              FollowRequestDataEvent(
                                context: context,
                                toUserId: profileData?.userId ?? "",
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: buttonColor,
                            ),
                            child: Center(
                              child:
                              state is FollowRequestLoading
                                  ? const SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                buttonText,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColor.bgTile,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'This week',
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Distance',
                                              style: CustomTextStyles.regular(
                                                fontSize: 12,
                                                textColor: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '0 km',
                                              style: CustomTextStyles.regular(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pace',
                                              style: CustomTextStyles.regular(
                                                fontSize: 12,
                                                textColor: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '0 m',
                                              style: CustomTextStyles.regular(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Elev Gain',
                                              style: CustomTextStyles.regular(
                                                fontSize: 12,
                                                textColor: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '0 m',
                                              style: CustomTextStyles.regular(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 200,
                                    color: AppColor.bgTile,
                                    // background color
                                    padding: const EdgeInsets.all(8),
                                    child: LineChart(
                                      LineChartData(
                                        backgroundColor: AppColor.bgTile,
                                        gridData: FlGridData(show: false),
                                        // grid lines hide
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  '${value.toInt()} km',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 30,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  '${value.toInt()} m',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: const [
                                              FlSpot(0, 0),
                                              FlSpot(1, 0),
                                              FlSpot(2, 0),
                                              FlSpot(3, 2),
                                              FlSpot(4, 0),
                                              FlSpot(5, 0),
                                              FlSpot(6, 0),
                                            ],
                                            isCurved: false,
                                            color: Colors.redAccent,
                                            barWidth: 2,
                                            dotData: FlDotData(show: true),
                                            belowBarData: BarAreaData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    var userId = profileData?.userId;
                                    if(userId != null){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ActivitiesScreen(userId: userId,),
                                        ),
                                      );
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("There is some issue while getting user")),
                                                   );
                                    }
                                  },
                                  leading: SvgPicture.asset(
                                    AppImageSvg.activities,
                                  ),
                                  title: Text(
                                    'Activities',
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'July 12, 2025',
                                    style: CustomTextStyles.regular(
                                      fontSize: 10,
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => StatisticsScreen(),
                                      ),
                                    );
                                  },
                                  leading: SvgPicture.asset(
                                    AppImageSvg.statistics,
                                  ),
                                  title: Text(
                                    'Statistics',
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'July 12, 2025',
                                    style: CustomTextStyles.regular(
                                      fontSize: 10,
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TrophyCase(categoryId: '',),
                                      ),
                                    );
                                  },
                                  leading: SvgPicture.asset(AppImageSvg.trophy),
                                  title: Text(
                                    'Trophy Case',
                                    style: CustomTextStyles.semiBold(
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'July 12, 2025',
                                    style: CustomTextStyles.regular(
                                      fontSize: 10,
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Trophy Case',
                                      style: CustomTextStyles.semiBold(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '3',
                                      style: CustomTextStyles.regular(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),

                                buildBadgeGrid(milestone),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'All Trophies',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ) /*CustomTextStyles.regular(fontSize: 16)*/,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Challenges',
                                      style: CustomTextStyles.semiBold(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '1',
                                      style: CustomTextStyles.regular(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),

                                // ListView.builder(
                                //   padding: EdgeInsets.zero,
                                //   shrinkWrap: true,
                                //   itemCount: challenges.length,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   itemBuilder: (context, index) {
                                //     final duration = Constant.calculateChallengeDuration(
                                //       challenges[index].startDate,
                                //       challenges[index].endDate,
                                //     );
                                //     return ListTile(
                                //       onTap: () {
                                //         Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesActiveScreen(challengeId: challenges[index].challengeId.toString(),)));
                                //       },
                                //       contentPadding: EdgeInsets.zero,
                                //       leading: (challenges[index].challengeIcon != null && challenges[index].challengeIcon != 'null' &&
                                //           challenges[index].challengeIcon!.isNotEmpty)
                                //           ? CachedNetworkImage(
                                //         imageUrl: challenges[index].challengeIcon!,
                                //         height: 50,
                                //         width: 50,
                                //         imageBuilder: (context, imageProvider) => ClipOval(
                                //           child: Image(
                                //             image: imageProvider,
                                //             height: 50,
                                //             width: 50,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //         placeholder: (context, url) => ClipOval(
                                //           child: SvgPicture.asset(
                                //             AppImageSvg.activeUser,
                                //             height: 50,
                                //             width: 50,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //         errorWidget: (context, url, error) => ClipOval(
                                //           child: SvgPicture.asset(
                                //             AppImageSvg.activeUser,
                                //             height: 50,
                                //             width: 50,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       )
                                //           : ClipOval(
                                //         child: SvgPicture.asset(
                                //           AppImageSvg.activeUser,
                                //           height: 50,
                                //           width: 50,
                                //           fit: BoxFit.cover,
                                //         ),
                                //       ),
                                //
                                //       title: Text(challenges[index].title.toString()/*'Timeout Streaks Challenge\nJuly 2025'*/),
                                //       subtitle: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Row(
                                //             children: [
                                //               Image.network(challenges[index].categoryIcon.toString(), height: 15, color: Colors.grey,),
                                //               Text(' --/${duration['weeks']} weeks', style: TextStyle(color: Colors.grey),)
                                //             ],
                                //           ),
                                //           Text('${duration['daysLeft']} days left', style: TextStyle(color: Colors.grey))
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserAllChallenges(user_Id: widget.userId,)));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'All Challenge',
                                        style: CustomTextStyles.regular(
                                          textColor: AppColor.bgRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'Clubs',
                                //       style: CustomTextStyles.semiBold(
                                //         fontSize: 16,
                                //       ),
                                //     ),
                                //     Text(
                                //       '2',
                                //       style: CustomTextStyles.regular(
                                //         fontSize: 16,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 20),
                                // GridView.builder(
                                //   gridDelegate:
                                //       SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisCount: 2,
                                //         mainAxisSpacing: 8,
                                //         crossAxisSpacing: 8,
                                //         mainAxisExtent: 110,
                                //       ),
                                //   padding: EdgeInsets.symmetric(vertical: 10),
                                //   shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   // ✅ Important
                                //   itemCount: 2,
                                //   itemBuilder: (context, index) {
                                //     return Container(
                                //       padding: EdgeInsets.all(10),
                                //       decoration: BoxDecoration(
                                //         color: AppColor.bgTile,
                                //         borderRadius: BorderRadius.circular(12),
                                //       ),
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //         children: [
                                //           Center(
                                //             child: Image.asset(
                                //               AppImageOthers.clubDP,
                                //               height: 55,
                                //             ),
                                //           ),
                                //           SizedBox(height: 5),
                                //           Text(
                                //             'Pinkcity Runners',
                                //             style: CustomTextStyles.semiBold(
                                //               fontSize: 15,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Text(
                                //       'All clubs',
                                //       style: CustomTextStyles.regular(
                                //         textColor: AppColor.bgRed,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            );
          }

          if (state is OtherProfileError) {
            return Center(child: Text(state.error));
          }

          return SizedBox();
        },
      ),
    );
  }

  void showUnfollowDialog(
    BuildContext parentContext,
    String userId,
    dynamic profileData,
  ) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to unfollow?',
                    style: CustomTextStyles.bold(
                      fontSize: 16,
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: 'Yes',
                        width: 110,
                        callback: () {
                          Navigator.pop(parentContext);
                          // ✅ Unfollow confirmed
                          (parentContext as Element).markNeedsBuild();
                          profileData.isFollowed = false;
                          profileData.isFollowRequested = false;

                          parentContext.read<FollowRequestBloc>().add(
                            FollowRequestDataEvent(
                              context: parentContext,
                              toUserId: userId,
                            ),
                          );
                        },
                      ),
                      CustomButton(
                        text: 'No',
                        width: 110,
                        callback: () {
                          Navigator.pop(parentContext);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget buildBadgeGrid(List<Map<String, String>> badges) {
    List<Widget> rows = [];

    for (int i = 0; i < badges.length; i += 3) {
      final rowItems = badges.skip(i).take(3).toList();

      rows.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // ✅ background per row
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                rowItems.map((badge) {
                  return Column(
                    children: [
                      Image.asset(badge["image"]!, height: 75, width: 70),
                      SizedBox(height: 8),
                      Text(
                        badge["title"]!,
                        style: CustomTextStyles.semiBold(fontSize: 12),
                      ),

                      if (badge["subTitle"] != null &&
                          badge["subTitle"]!.isNotEmpty)
                        Text(
                          badge['subTitle']!,
                          style: CustomTextStyles.regular(fontSize: 12),
                        ),
                    ],
                  );
                }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  void _showCupertinoMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                isDefaultAction: true,
                child: Text(
                  "Report Profile",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // ✅ Block logic
                },
                isDestructiveAction: true,
                child: Text(
                  "Block",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
    );
  }
}
