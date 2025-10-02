import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_State.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_state.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/models/categoryModel.dart';
import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'challangesDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class challengesWidget extends StatefulWidget {
  const challengesWidget({Key? key}) : super(key: key);

  @override
  _challengesWidgetState createState() => _challengesWidgetState();
}

class _challengesWidgetState extends State<challengesWidget> {
  String  filter = "";
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
    context.read<SuggestedBloc>().add(PostSuggestedEvent(
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
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) => buildFilterButton(cat)).toList(),
            ),
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: BlocConsumer<SuggestedBloc, SuggestedState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PostSuggestedLoading) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: AppColor.bgRed,
                      size: 20,
                    ),
                  );
                }


                if (state is PostSuggestedSuccess) {
                  var suggestedData = state.suggestedModel.data?.data ?? [];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(AppImageOthers.challengesBanner, fit: BoxFit.cover),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended For You',
                                  style: CustomTextStyles.bold(fontSize: 18),
                                ),
                                Text(
                                  'Based on your activities',
                                  style: CustomTextStyles.regular(
                                    fontSize: 11,
                                    textColor: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Challenges grid
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.80, // auto height/width ratio
                              ),
                              itemCount: suggestedData.length,
                              itemBuilder: (context, index) {
                                final challenge = suggestedData[index];
                                isJoined = challenge.isJoined.toString();
                                return _buildChallengeCard(challenge, context);
                              },
                            )
                            ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is PostSuggestedError) {
                  return Center(child: Text(state.error));
                }

                return SizedBox();
              },
            ),
          ),
        ),
      ],
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

  Widget _buildChallengeCard(ChallengesData challenge, BuildContext context) {
    var title = challenge.title ?? "Challenge";
    var description = challenge.description ?? "N/A";
    var date = formatDateRange(challenge.startDate, challenge.endDate);

    var icon = challenge.categoryIcon ?? "";
    final imageUrl = icon.startsWith("http") ? icon : "${Api.BaseUrl}$icon";

    var challengesId = challenge.challengeId!;

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesDetailScreen(isAlreadyJoined: challenge.isJoined)));

      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8993FF).withAlpha(80), Colors.white.withAlpha(10)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      SvgPicture.asset(AppImageSvg.run, color: Colors.black),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
        BlocConsumer<JoinChalllengesBloc, JoinchallengesState>(
          listener: (context, state) {
            if (state is PostJoinchallengesSuccess && state.challengeId == challengesId.toString()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.joinChallengesModel.message.toString())),
              );

              setState(() {
                challenge.isJoined = true;
              });

            }

            if (state is PostJoinchallengesError && state.challengeId == challengesId.toString()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            bool isLoading = state is PostJoinchallengesLoading && state.challengeId == challengesId.toString();


            return SizedBox(
              height: 35,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.bgRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                ),
                onPressed: () {
                  if (isLoading) return;

                  if (challenge.isJoined == true) {
                  if (state is PostJoinchallengesSuccess &&
                  state.challengeId == challengesId.toString()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.joinChallengesModel.message ?? "Already Joined")),
                  );
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You have already joined this challenge")),
                  );
                  }
                  return;
                  }
                  context.read<JoinChalllengesBloc>().add(
                    PostJoinChallengesEvent(
                      challenges_Id: challengesId.toString(),
                      context: context,
                    ),
                  );


                },
                child: isLoading
                    ? LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 20,
                )
                    : Text(
                  challenge.isJoined == true ? "Joined" : "Join Now",
                  style: CustomTextStyles.bold(
                    textColor: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        )

        ],
        ),
      ),
    );
  }

  String formatDateRange(String? start, String? end) {
    if (start == null || end == null) return "";

    try {
      DateTime startDate = DateTime.parse(start);
      DateTime endDate = DateTime.parse(end);

      // Month short names
      const monthNames = [
        "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];

      String startStr = "${monthNames[startDate.month]} ${startDate.day.toString().padLeft(2,'0')}";
      String endStr = "${monthNames[endDate.month]} ${endDate.day.toString().padLeft(2,'0')}, ${endDate.year}";

      return "$startStr to $endStr";
    } catch (e) {
      return "";
    }
  }

}
