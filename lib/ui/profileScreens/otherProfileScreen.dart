import 'package:coherent_endurance/bloc/profileBloc/otherProfile_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_state.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/settingScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/statisticsScreen.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/ui/trophyCase.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resources/color/appColor.dart';
import 'activitiesScreen.dart';
import 'editProfileScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OtherProfileScreen extends StatefulWidget {
  String path;

  OtherProfileScreen({this.path = 'user', super.key});

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
    var userId = widget.path;
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
            var firstName = profileData?.firstName?? "N/A";
            var lastName = profileData?.lastName?? "N/A";
            var bio = profileData?.bio?? "N/A";
            var address = profileData?.address?? "N/A";
            var city = profileData?.city?? "N/A";
            var country = profileData?.country?? "N/A";
            var stateName = profileData?.state?? "N/A";
            var totalFollowers = profileData?.totalFollowers?? "";
            var totalFollowing = profileData?.totalFollowing?? "";

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
                                      widget.path == 'user'
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
                                        ) /*SvgPicture.asset(AppImageSvg.setting)*/,
                                      ),
                                      // SizedBox(width: 10,),
                                      // SvgPicture.asset(AppImageSvg.option),
                                      SizedBox(width: 10),

                                      widget.path == 'user'
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
                                            ) /*SvgPicture.asset(AppImageSvg.setting)*/,
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
                      widget.path == 'user'
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

                      // Positioned(
                      //   bottom: 10,
                      //     left: 0,
                      //     right: 0,
                      //     child: Column(
                      //       children: [
                      //         Text('Adam Smith', style: CustomTextStyles.bold(fontSize: 26 ),),
                      //         Text('Jaipur, India', style: CustomTextStyles.medium(fontSize: 17),),
                      //       ],
                      //     )
                      // )
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

                  BlocConsumer<OtherProfileBloc, OtherProfileState>(
                    listener: (context, state) {
                      if (state is FollowRequestLoading) {
                        Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: AppColor.bgRed,
                            size: 20,
                          ),
                        );
                      }

                      if (state is FollowRequestSuccess) {
                        var message =
                            state.followRequestModel.message.toString();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));

                        setState(() {
                          profileData?.isFollowRequested = true;
                        });
                      }

                      if (state is FollowRequestError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      //  Already Following
                      if (profileData?.isFollowed == true) {
                        return Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.bgRed,
                          ),
                          child: const Center(
                            child: Text(
                              "Following",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      //  Follow Request already sent
                      if (profileData?.isFollowRequested == true) {
                        return Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.bgRed,
                          ),
                          child: const Center(
                            child: Text(
                              "Requested",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          context.read<OtherProfileBloc>().add(
                            FollowRequestDataEvent(
                              context: context,
                              toUserId: profileData?.userId ?? "",
                            ),
                          );
                        },
                        child: Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.bgRed,
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
                                    : const Text(
                                      "Follow",
                                      style: TextStyle(color: Colors.white),
                                    ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColor.bgTile,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ActivitiesScreen(),
                                      ),
                                    );
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
                                        builder: (context) => TrophyCase(),
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
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SvgPicture.asset(
                                    AppImageSvg.activeUser,
                                    height: 51,
                                  ),
                                  title: Text(
                                    'Timeout Streaks Challenge\nJuly 2025',
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImageSvg.run,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            ' --/4 weeks',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '10 days left',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
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
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Clubs',
                                      style: CustomTextStyles.semiBold(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '2',
                                      style: CustomTextStyles.regular(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        mainAxisExtent: 110,
                                      ),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  // ✅ Important
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.bgTile,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Image.asset(
                                              AppImageOthers.clubDP,
                                              height: 55,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Pinkcity Runners',
                                            style: CustomTextStyles.semiBold(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'All clubs',
                                      style: CustomTextStyles.regular(
                                        textColor: AppColor.bgRed,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                  // ✅ Report Profile logic
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
