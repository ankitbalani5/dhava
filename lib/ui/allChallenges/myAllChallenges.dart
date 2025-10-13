import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_Event.dart';
import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_State.dart';
import 'package:coherent_endurance/models/myJoinedAllChallengesModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/challenges/challangesDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MyAllChallenges extends StatefulWidget {
  final String? categoryID ;
  const MyAllChallenges({super.key,required this.categoryID});

  @override
  State<MyAllChallenges> createState() => _MyAllChallengesState();
}

class _MyAllChallengesState extends State<MyAllChallenges> {


  int page = 1;
  final RefreshController _refreshController = RefreshController();


  @override
  void initState() {
    super.initState();
    _fetchMyAllChallenges();

  }

  _fetchMyAllChallenges({bool isPagination = false}) {
    context.read<MyjoinedChallengesBloc>().add(GetMyjoinedChallengesEvent(
      context: context,
      perPage: '10',
      page: page.toString(),
      isPagination: isPagination,
      categoryId: widget.categoryID ?? "",
    ));

  }



  void _onRefresh() {
    page = 1;
    _fetchMyAllChallenges();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    _fetchMyAllChallenges(isPagination: true);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('My All Challenges', style: CustomTextStyles.bold()),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: BlocConsumer<MyjoinedChallengesBloc, MyjoinedChallengesState>(
          listener: (context, state) {},
          builder:  (context, state) {

            if (state is MyjoinedChallengesLoading) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: AppColor.bgRed,
                  size: 20,
                ),
              );
            }

            if (state is MyjoinedChallengesSuccess) {
              var myJoinedData = state.myJoinedChallengesModel.data?.data ?? [];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        itemCount: myJoinedData.length,
                        itemBuilder: (context, index) {
                          final challenge = myJoinedData[index];
                          return _buildChallengeCard(challenge, context);
                        },
                      )
                  
                    ],
                  ),
                ),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
  Widget _buildChallengeCard(Data challenge, BuildContext context) {
    var title = challenge.title ?? "Challenge";
    var description = challenge.description ?? "N/A";
    var date = formatDateRange(challenge.startDate, challenge.endDate);
    var icon = challenge.categoryIcon ?? "";
    final imageUrl = icon.startsWith("http") ? icon : "${Api.BaseUrl}$icon";
    var challengesId = challenge.challengeId!;

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesDetailScreen(challengeId: challengesId,)));

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


