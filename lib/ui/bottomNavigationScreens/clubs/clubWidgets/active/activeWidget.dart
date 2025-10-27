
import 'package:coherent_endurance/bloc/activeChallengeBloc/active_challenge_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/active/challangesActive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveWidget extends StatefulWidget {
  const ActiveWidget({Key? key}) : super(key: key);

  @override
  _ActiveWidgetState createState() => _ActiveWidgetState();
}

class _ActiveWidgetState extends State<ActiveWidget> {
  String filter = '';
  double _progress = 0.4;
  double _oldProgress = 0.0;


  void updateProgress(double newValue) {
    setState(() {
      _oldProgress = _progress;
      _progress = newValue;
    });
  }

  // String  filter = "";
  int page = 1;
  final RefreshController _refreshController = RefreshController();
  List<CategoryModelData> categories = [];
  late String isJoined ;


  @override
  void initState() {

    super.initState();
    var categoriesData = Constant.getCategory?.data ?? [];
    categories = [ CategoryModelData(
      categoryId: "",
      categoryName: "All",
      categoryIcon: null,
    ) ] + categoriesData;

    _fetchChallenges();

  }

  _fetchChallenges({bool isPagination = false}) {
    context.read<ActiveChallengeBloc>().add(FetchActiveChallengeEvent(
      context: context,
      perPage: '10',
      page: page.toString(),
      categoryId: filter,
      isPagination: isPagination,
    ));
    print('filter:::$filter');
  }


  void _onRefresh() {
    page = 1;
    _fetchChallenges();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    _fetchChallenges(isPagination: true);
    _refreshController.loadComplete();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:0),
      child: Column(
        children: [
          BlocBuilder<ActiveChallengeBloc, ActiveChallengeState>(
            builder: (context, state) {
              if(state is ActiveChallengeSuccess){
                return state.activeChallengeModel.data!.data!.isEmpty
                    ? SizedBox()
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical:0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) => buildFilterButton(cat)).toList(),
                    ),
                  ),
                );
              }
              return SizedBox();
            },
          ),


          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: BlocConsumer<ActiveChallengeBloc, ActiveChallengeState>(
                listener: (context, state) {
                },
                builder: (context, state) {
                  if(state is ActiveChallengeLoading){
                    return Center(child: Constant.loadingAnimation());
                  }
                  if(state is ActiveChallengeSuccess){
                    return state.activeChallengeModel.data!.data!.isEmpty
                        ?  Center(child: Text('No Data Available'))
                        :
                      SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Image.asset(AppImageOthers.activeBanner),
                          SizedBox(height: 20,),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.activeChallengeModel.data?.data?.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var activeData = state.activeChallengeModel.data!.data?[index];
                              final duration = Constant.calculateChallengeDuration(
                                activeData!.startDate,
                                activeData.endDate,
                              );
                              var startDate = DateTime.parse(activeData.startDate ?? '');
                              var endDate = DateTime.parse(activeData.endDate ?? '');
                              double _progress = Constant.calculateProgress(startDate, endDate);

                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChallangesActiveScreen(challengeId: activeData.challengeId.toString(),)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: activeData.challengeIcon ?? '',
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
                                                child: Text(activeData!.title ?? ''/*'Timeout Streaks Challenge July 2025'*/, style: CustomTextStyles.semiBold(fontSize: 16),)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: CachedNetworkImage(
                                                          imageUrl: activeData.categoryIcon ?? '',
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
                                                              Image.asset(AppImageOthers.defaultImage,width: 90,
                                                                height: 90,),
                                                        )
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
                              );
                            },),
                        ],
                      ),
                    );
                  }
                  if(state is ActiveChallengeError){
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          )

        ],
      ),
    );
  }


  Widget buildFilterButton(CategoryModelData category) {
    bool isSelected = filter == category.categoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          filter = category.categoryId ?? "";
          page = 1;
        });
        _fetchChallenges(); // fetch filtered data
      },

      child: Container(
        height: 45,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColor.bgRed : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (category.categoryIcon != null)
              Image.network(
                category.categoryIcon!,
                height: 20,
                width: 20,
                color: isSelected ? AppColor.bgRed : Colors.black,
              ),
            if (category.categoryIcon != null) const SizedBox(width: 5),
            Text(
              category.categoryName ?? "",
              style: CustomTextStyles.regular(
                fontSize: 10,
                textColor: isSelected ? AppColor.bgRed : Colors.black,
              ),
            ),
            if (category.categoryId != "") const SizedBox(width: 5),
            if (category.categoryId != "") SvgPicture.asset(
              AppImageSvg.cancel,
              color: isSelected ? AppColor.bgRed : Colors.black,
            ),
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

