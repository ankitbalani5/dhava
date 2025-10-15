import 'package:coherent_endurance/bloc/MyFeedBloc/my_feed_bloc.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/models/MyFeedModel.dart';
import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart' show AppImageOthers, AppImageSvg;
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/home/feedDetails.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivitiesScreen extends StatefulWidget {
 final String userId;
  const ActivitiesScreen({super.key,this.userId=''});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String filter = 'all';
  int selectedIndex = 0;
  String categoryId = '';
  CategoryModel? categoryData;
  int page = 1;
  final RefreshController _refreshController = RefreshController();

  _loadPage(){
    context.read<MyFeedBloc>().add(GetMyFeedEvent(perPage: '10', page: page.toString(), categoryId: categoryId, context: context,userId: widget.userId));
  }

  void _onRefresh() {
    page = 1;
    _loadPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    context.read<MyFeedBloc>().add(GetMyFeedEvent(
        context: context,
        perPage: '10',
        page: page.toString(),
        categoryId: categoryId,
        userId: widget.userId,
        isPagination: true
    ));
    _refreshController.loadComplete();
  }

  @override
  void initState() {

_loadPage();
    categoryData = CategoryModel(
        data: [
          CategoryModelData(
              categoryId: '',
              categoryName: 'All',
              backgroundImage: '',
              categoryIcon: '',
              tips: '',
              uniqueCode: ''
          ),
          if (Constant.getCategory?.data != null)
            ...Constant.getCategory!.data!
        ]
    );

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()),
        title: Text('Activities', style: CustomTextStyles.bold(),),
      ),
      body: Column(
        children: [

          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  categoryData?.data?.length ?? 0,
                      (index) {
                    final isSelected = selectedIndex == index;
                    final category = categoryData!.data![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            page = 1;
                            selectedIndex = index;
                            categoryId = category.categoryId ?? '';

                            _loadPage();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: category.categoryName!.toLowerCase() == 'all' ? 15 : 12,
                              vertical: category.categoryName!.toLowerCase() == 'all' ? 11 : 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColor.bgRed : Colors.black,
                            ),
                            color: Colors.white, // Background stays white
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (category.categoryIcon != null &&
                                  category.categoryIcon!.isNotEmpty)
                                Image.network(
                                  category.categoryIcon!,
                                  height: 20,
                                  width: 20,
                                  color: isSelected ? AppColor.bgRed : Colors.black,
                                ),
                              if (category.categoryIcon != null &&
                                  category.categoryIcon!.isNotEmpty)
                                const SizedBox(width: 5),
                              Text(
                                category.categoryName ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected ? AppColor.bgRed : Colors.black,
                                ),
                              ),
                              if (index != 0) // Show close icon for other categories, not "All"
                                const SizedBox(width: 5),
                              if (index != 0 && category.categoryIcon != null)
                                SvgPicture.asset(
                                  AppImageSvg.cancel,
                                  height: 12,
                                  color: isSelected ? AppColor.bgRed : Colors.black,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          BlocConsumer<MyFeedBloc, MyFeedState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              if(state is MyFeedLoading){
                return Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.white,
                    size: 20,
                  ),
                );
              }
              if(state is MyFeedSuccess){
                var feedData = state.feedModel.data!.data;
                return Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      itemCount: feedData!.length,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var feed = feedData[index];
                        print('feedData::::$feed');
                        var feedData1 = state.feedModel.data!.data ?? [];

                        if (feedData1.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                "No data available",
                                style: CustomTextStyles.semiBold(fontSize: 14),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetails(activityId: feed.activityId.toString(),)));
                            },
                            child: Container(
                              color: Colors.white24,
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.red, width: 1), // 🔴 red border
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: feed.profilePic.toString()
                                                  /*AppImageOthers.userImg*/,
                                                  height: 30, width: 30, fit: BoxFit.fill,
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

                                                      Image.network(feed.categoryIcon.toString(), height: 15, color: AppColor.bgRed,),
                                                      // Image.asset(AppImageOthers.feedRun, height: 16,),
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
                                              Text('${Constant.formatPace(double.parse(feed.pace.toString()))} /km', style: CustomTextStyles.regular(fontSize: 16)),
                                            ],
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Time', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey)),
                                              Text(Constant.formatDuration(int.parse(feed.movingTime.toString())), style: CustomTextStyles.regular(fontSize: 16)),
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
                                        fit: BoxFit.fill, height: 260,width: double.infinity)),

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
                                                      context.read<MyFeedBloc>().add(MyFeedLikeEvent(context: context, activityId: feed.activityId.toString()));
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => KudosScreen()));
                                                    },
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Icon(Icons.thumb_up, color: feed.isLiked == true ? AppColor.bgRed : Colors.black,))),

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

                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 20,),
                                  // Divider(color: Colors.black,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
              if(state is MyFeedError){
                return Center(
                  child: Text(state.error),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  static Widget likeImageWidget (MyFeedModelData feed){
    return BlocConsumer<MyFeedBloc, MyFeedState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is MyFeedSuccess) {
          // final feed = state.feedModel.data!;
          final likedUsers = feed.likedUsers ?? [];

          if (likedUsers.isEmpty) {
            return const SizedBox();
          }

          final visibleUsers = likedUsers.take(4).toList();

          return SizedBox(
            width: feed.likedUsers?.length == 1 ? 32 : feed.likedUsers?.length == 2 ? 58 : feed.likedUsers?.length == 3 ? 84 : 110,
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
                        border: Border.all(color: Colors.red, width: 1),
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

        return SizedBox();

      },
    );
  }
}

