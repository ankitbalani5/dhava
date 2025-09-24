import 'package:coherent_endurance/models/feedModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/editProfileScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coherent_endurance/ui/trophyCase.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/discussion.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/ui/completeProfile/createProfile.dart';
import 'package:coherent_endurance/ui/completeProfile/uploadPhotoScreen.dart';
import 'package:coherent_endurance/ui/milestone.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../bloc/activityBloc/activity_bloc.dart';
import '../../../bloc/profileBloc/profile_bloc.dart';
import '../../../widgets/backButton.dart';
import '../../completeProfile/weightScreen.dart';
import '../../notification/notificationScreen.dart';
import '../../profileScreens/profileScreen.dart';
import 'feedDetails.dart';
import 'kudosScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int page = 1;
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    context.read<ActivityBloc>().add(GetFeedEvent(
        context: context,
        perPage: '2',
        page: '1',
        categoryId: null,
    ));
    super.initState();
  }
  void _onRefresh() {
    page = 1;
    context.read<ActivityBloc>().add(GetFeedEvent(context: context, perPage: '10', page: page.toString(), categoryId: null,));
    context.read<ProfileBloc>().add(GetProfileEvent(context, ''));
    context.read<ProfileBloc>().add(CategoryEvent(context));
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    context.read<ActivityBloc>().add(GetFeedEvent(
      context: context,
      perPage: '10',
      page: page.toString(),
      categoryId: null,
      isPagination: true
    ));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: BackButtonWidget(),
        automaticallyImplyLeading: false,
        title: Text('Home', style: CustomTextStyles.bold(),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.search,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.notification,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    AppImageOthers.defaultImage,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if(state is FeedLoading){

            }
            if(state is FeedSuccess){

            }
          },
          builder: (context, state) {
            if(state is FeedLoading){
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: AppColor.bgRed,
                  size: 20,
                ),
              );
            }
            if(state is FeedSuccess){
              var feedData = state.feedModel.data!.data;
              return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keep that momentum going!', style: CustomTextStyles.semiBold(fontSize: 24),),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColor.bgTile,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                          color: AppColor.bgRed,
                                        ),
                                      )),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: AppColor.bgTile,
                                        ),
                                      )),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                          color: AppColor.bgTile,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text('1/3')
                            ],
                          ),
                          SizedBox(height: 10,),

                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar(i: 2,)));

                              bottomNavKey.currentState?.changeTab(2);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.bgTile, // 👈 Yaha color diya
                                borderRadius: BorderRadius.circular(20), // 👈 Proper rounded corners
                              ),
                              child: ListTile(
                                // tileColor: AppColor.bgTile,

                                // contentPadding: EdgeInsets.zero,
                                leading: SvgPicture.asset(AppImageSvg.run, color: Colors.black, height: 42, width: 42,),
                                title: Text('Upload your first activity', style: CustomTextStyles.semiBold(fontSize: 14),),
                                subtitle: Text('You can record it right in the app.', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                trailing: Icon(Icons.arrow_forward_ios, color: AppColor.bgRed,),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.bgTile, // 👈 Yaha color diya
                                borderRadius: BorderRadius.circular(20), // 👈 Proper rounded corners
                              ),
                              child: ListTile(
                                // tileColor: AppColor.bgTile,
                                // contentPadding: EdgeInsets.zero,
                                leading: SvgPicture.asset(AppImageSvg.groupImage, color: Colors.black, height: 42, width: 42,),
                                title: Text('Follow three people', style: CustomTextStyles.semiBold(fontSize: 14),),
                                subtitle: Text('Find friends and fan favorites to follow.', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                trailing: Icon(Icons.arrow_forward_ios, color: AppColor.bgRed,),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.bgTile, // 👈 Yaha color diya
                                borderRadius: BorderRadius.circular(20), // 👈 Proper rounded corners
                              ),
                              child: ListTile(
                                // tileColor: AppColor.bgTile,
                                // contentPadding: EdgeInsets.zero,
                                leading: SvgPicture.asset(AppImageSvg.person, color: Colors.black, height: 42, width: 42,),
                                title: Text('Add your profile photo', style: CustomTextStyles.semiBold(fontSize: 14),),
                                subtitle: Text('Find friends and fan favorites to follow.', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                trailing: Icon(Icons.arrow_forward_ios, color: AppColor.bgRed,),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text('Suggested Challenges', style: CustomTextStyles.semiBold(fontSize: 24)),
                          Text('Make accountability a little easier. more fun and earn rewards!', style: CustomTextStyles.semiBold(fontSize: 14)),

                          // SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    Container(
                      color: AppColor.bgTile,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  height: 210,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 160,
                                        padding: EdgeInsets.all(15),
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          // borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(image: AssetImage('assets/image/others/bgChallenge.png'))
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('July Run 100K \nChallenge', style: CustomTextStyles.semiBold(fontSize: 16)),
                                            SizedBox(height: 4,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(AppImageSvg.run, color: Colors.black,),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                        width: 100,
                                                        child: Text('Run a total of 100 km(62.1 mi) in a month.', style: CustomTextStyles.regular(fontSize: 12))),

                                                    SizedBox(
                                                        width: 100,
                                                        child: Text('Jul 1 to Jul31, 2025', style: CustomTextStyles.regular(fontSize: 12))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15,),
                                            Center(
                                              child: Container(
                                                width: 100,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: AppColor.bgRed
                                                ),
                                                child: Center(
                                                  child: Text('Join Now', style: CustomTextStyles.bold(fontSize: 14, textColor: Colors.white)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),

                          GestureDetector(
                              onTap: () {

                                bottomNavKey.currentState?.changeTab(3);
                              },
                              child: Center(child: Text('Explore all Challenges', style: CustomTextStyles.bold(textColor: AppColor.bgRed),))),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.builder(
                        itemCount: feedData!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var feed = feedData[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetails()));
                            },
                            child: Container(
                              color: Colors.white24,
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.red, width: 1), // 🔴 red border
                                            ),
                                            child: ClipOval(
                                              child: CachedNetworkImage(imageUrl: feed.profilePic.toString()
                                                /*AppImageOthers.userImg*/, height: 30, width: 30, fit: BoxFit.fill,
                                                errorWidget: (context,
                                                    url, error) =>
                                                    Image.asset(AppImageOthers.userImg, height: 30, width: 30,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${feed.firstName.toString()} ${feed.lastName}', style: CustomTextStyles.regular(fontSize: 14),),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*.75,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(AppImageOthers.feedRun, height: 16,),
                                                    SizedBox(width: 5,),
                                                    Expanded(
                                                      child: Text('${feed.location}'/*'August 15, 2024 at 8:20 AM Iskandar Puteri, Malaysia'*/,
                                                          // maxLines: 2,
                                                          style: CustomTextStyles.regular(fontSize: 11,
                                                              textColor: Colors.grey)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Text(feed.title.toString(), style: CustomTextStyles.semiBold(fontSize: 16),),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Distance', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                              // Text('${(double.parse(feed.distance.toString()) / 1000).toStringAsFixed(2)} km', style: CustomTextStyles.regular(fontSize: 16)),
                                              Text(
                                                (double.tryParse(feed.distance.toString()) ?? 0) >= 1000
                                                    ? '${(double.parse(feed.distance.toString()) / 1000).toStringAsFixed(2)} km'
                                                    : '${feed.distance} m',
                                                style: CustomTextStyles.regular(fontSize: 16),
                                              )                                          ],
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Pace', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                              Text('${feed.pace} /km', style: CustomTextStyles.regular(fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                              Text(feed.movingTime.toString(), style: CustomTextStyles.regular(fontSize: 16)),
                                            ],
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(imageUrl: feed.photo.toString()/*AppImageOthers.feedImg*/,
                                        fit: BoxFit.fill, height: 260,)),

                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(/*horizontal: 10.0, */vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                likeImageWidget(feed),
                                                SizedBox(width: 10,),
                                                Text('${feed.totalLike} gave kudos', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey),),

                                              ],
                                            ),

                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      context.read<ActivityBloc>().add(ActivityLikeEvent(context: context, activityId: feed.activityId.toString()));
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                                    },
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Icon(Icons.thumb_up, color: Colors.black,))),

                                                SizedBox(width: 10,),
                                                GestureDetector(
                                                    onTap: () {
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Badges()));
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                                                    },
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Icon(Icons.share, color: Colors.black,))),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),

                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        //   children: [
                                        //     GestureDetector(
                                        //         onTap: () {
                                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                        //         },
                                        //         child: SizedBox(
                                        //             height: 30,
                                        //             width: 30,
                                        //             child: Icon(Icons.thumb_up, color: Colors.white,))),
                                        //     GestureDetector(
                                        //         onTap: () {
                                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => Discussion()));
                                        //         },
                                        //         child: SizedBox(
                                        //             height: 30,
                                        //             width: 30,
                                        //             child: Icon(Icons.message, color: Colors.white,))),
                                        //     GestureDetector(
                                        //         onTap: () {
                                        //           // Navigator.push(context, MaterialPageRoute(builder: (context) => Badges()));
                                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                                        //         },
                                        //         child: SizedBox(
                                        //             height: 30,
                                        //             width: 30,
                                        //             child: Icon(Icons.share, color: Colors.white,))),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 20,),
                                  // Divider(color: Colors.black,)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
            }
            if(state is FeedError){
              return Center(
                child: Text(state.error),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
  
  static Widget likeImageWidget (InnerData feed){
    return BlocConsumer<ActivityBloc, ActivityState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is FeedSuccess) {
          // final feed = state.feedModel.data!;
          final likedUsers = feed.likedUsers ?? [];

          if (likedUsers.isEmpty) {
            return const SizedBox();
          }

          // max 4 users ही दिखाने हैं
          final visibleUsers = likedUsers.take(4).toList();

          return SizedBox(
            width: feed.totalLike == 1 ? 32 : feed.totalLike == 2 ? 58 : feed.totalLike == 3 ? 84 : 110, // थोड़ा चौड़ा container ताकि overlap handle हो सके
            height: 40,
            child: Stack(
              children: List.generate(
                visibleUsers.length,
                    (index) {
                  final user = visibleUsers[index];
                  return Positioned(
                    right: index * 25, // overlap offset
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1), // 🔴 red border
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(imageUrl:
                          user.profilePic ?? "",
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          errorWidget: (context,
                              url, error) =>
                              Image.asset(AppImageOthers.userImg, height: 30, width: 30,),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        /*if(state is FeedSuccess){
          // var feed = state.feedModel.data!.data;
          return feed.totalLike! > 0 ?
            Stack(
            children: [
              Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(AppImageOthers.userImg, height: 30,),
                  ],
                ),
              ),

              Positioned(
                  right: 25,
                  child: Image.asset(AppImageOthers.userImg, height: 30,)),
              Positioned(
                  right: 50,
                  child: Image.asset(AppImageOthers.userImg, height: 30,)),
            ],
          ) : SizedBox();
        }*/
        return SizedBox();

      },
    );
  }
  
}
