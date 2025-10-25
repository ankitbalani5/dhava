
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_Event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_State.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Event.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class ChallangesDetailScreen extends StatefulWidget {
  final String? challengeId;
  const ChallangesDetailScreen({super.key,required this.challengeId});

  @override
  State<ChallangesDetailScreen> createState() => _ChallangesActiveDetailState();
}

class _ChallangesActiveDetailState extends State<ChallangesDetailScreen>  with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> leaderboard = List.generate(10, (index) => {
      "rank": (index + 1).toString(),
      "athlete": "Rajiv Malik",
      "distance": "153.72 km",
      "avatar":
      "https://cdn-icons-png.flaticon.com/512/194/194938.png", // sample avatar
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ChallengesDetailsBloc>().add(GetChallengesDetailsEvent(context: context,challengeId: widget.challengeId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<ChallengesDetailsBloc,ChallengesDetailsState>(

          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if(state is ChallengesDetailsLoading){
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: AppColor.bgRed,
                  size: 20,
                ),
              );
            }
            if(state is ChallengesDetailsSuccess){
              var title =  state.challengesDetailModel.data?.title.toString() ?? "";
              var categoryIcon =  state.challengesDetailModel.data?.categoryIcon.toString() ?? "";
              var challengeIcon =  state.challengesDetailModel.data?.challengeIcon.toString() ?? "";
              var description =  state.challengesDetailModel.data?.description.toString() ?? "";
              var isJoined =  state.challengesDetailModel.data?.isJoined;
              var startDate =  state.challengesDetailModel.data?.startDate.toString() ?? "";
              var endDate =  state.challengesDetailModel.data?.endDate.toString() ?? "";
              var date = formatDateRange(startDate, endDate);
              return  SafeArea(
                top: false,
                bottom: true,
                left: true,
                right: true,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppImageOthers.challangesRunBanner),
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

                        /// Back + Title
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
                              const SizedBox(width: 8),
                              Text("Challenges",
                                  style: CustomTextStyles.bold(
                                      textColor: Colors.black, fontSize: 14)),
                            ],
                          ),
                        ),

                        /// Right icons
                        // Positioned(
                        //   top: 40,
                        //   right: 15,
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //           height: 30,
                        //           child: Image.asset(AppImageOthers.notificationIcon)),
                        //       const SizedBox(width: 8),
                        //       SizedBox(
                        //           height: 30,
                        //           child: Image.asset(AppImageOthers.shareIcon)),
                        //     ],
                        //   ),
                        // ),

                        /// Logo bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ClipOval(
                              child: SizedBox(
                                width:80, // 🔹 smaller circular image
                                height: 80,
                                child: challengeIcon.isNotEmpty
                                    ? Image.network(
                                  challengeIcon,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColor.bgRed,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImageOthers.challengesLogo,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                    : Image.asset(
                                  AppImageOthers.challengesLogo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: 20),

                    isJoined == false ?  Center(
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.bgRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            context.read<JoinChalllengesBloc>().add(
                              PostJoinChallengesEvent(
                                challenges_Id: widget.challengeId,
                                context: context,
                              ),
                            );

                            await Future.delayed(const Duration(seconds: 1));

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChallangesDetailScreen(
                                  challengeId: widget.challengeId,
                                ),
                              ),
                            );
                          },

                          child: Text("Join Challenges",
                              style: CustomTextStyles.semiBold(
                                  fontSize: 14, textColor: Colors.white)),
                        ),
                      ),
                    ):SizedBox(),

                     SizedBox(height: 10),

                    /// Invite Friends Button
               /*     Center(
                      child: SizedBox(
                        width: 250,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColor.bgRed,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: Text("Invites Friends",
                              style: CustomTextStyles.semiBold(
                                  fontSize: 14, textColor: AppColor.bgRed)),
                        ),
                      ),
                    ),
*/
                     SizedBox(height: 20),

                    /// All remaining content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          /// Calendar Row
                          Row(
                            children: [
                              SizedBox(
                                  height: 30,
                                  child: Image.asset(AppImageOthers.calenderImg)),

                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  date,
                                  style: CustomTextStyles.semiBold(
                                      fontSize: 12,
                                      textColor: AppColor.textBackgroundGrey),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// Run Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              categoryIcon.isNotEmpty
                                  ? (categoryIcon.toLowerCase().endsWith('.svg')
                                  ? SvgPicture.network(
                                categoryIcon,
                                width: 30,
                                height: 30,
                                color: Colors.black,
                                placeholderBuilder: (context) => Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              )
                                  : Image.network(
                                categoryIcon,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  AppImageOthers.challengesLogo,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ))
                                  : Image.asset(
                                AppImageOthers.challengesLogo,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),



                              SizedBox(width: 8),

                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                     title,
                                      style: CustomTextStyles.semiBold(
                                          fontSize: 12,
                                          textColor: AppColor.textBackgroundGrey),maxLines: 1,
                                    ),
                                    Text(
                                     description,
                                      style: CustomTextStyles.semiBold(
                                          fontSize: 12, textColor: Colors.grey),maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                           SizedBox(height: 20),

                          /// Trophy Row
                          Row(
                            children: [
                              SizedBox(
                                  height: 30,
                                  child: Image.asset(AppImageOthers.trophyImg)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Earn a digital finisher's badge for your\nTrophy Case.",
                                  style: CustomTextStyles.semiBold(
                                      fontSize: 12,
                                      textColor: AppColor.textBackgroundGrey),
                                ),
                              ),
                            ],
                          ),



                          /// Club Row
       /*                   Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(AppImageOthers.clubDP, width: 70),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ORGANIZING CLUB",
                                      style: CustomTextStyles.semiBold(
                                          fontSize: 12,
                                          textColor: AppColor.textBackgroundGrey)),
                                  Text("We Runners Club",
                                      style: CustomTextStyles.semiBold(
                                          fontSize: 12,
                                          textColor: AppColor.textBackgroundGrey)),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppImageSvg.run,
                                          color: Colors.black),
                                      const SizedBox(width: 10),
                                      Text("6379270 athletes",
                                          style: CustomTextStyles.semiBold(
                                              fontSize: 12,
                                              textColor: AppColor.textBackgroundGrey)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),*/

                          const SizedBox(height: 20),

                          /// Join Club Button
                       /*   Center(
                            child: SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.bgRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {},
                                child: Text("Join Club",
                                    style: CustomTextStyles.semiBold(
                                        fontSize: 14, textColor: Colors.white)),
                              ),
                            ),
                          ),
*/
                          /// Overall Stats Widget
                  /*        overAllStats(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("December Running Challenge",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(
                                  "Setting a goal for yourself can grant you real superpowers. Working towards a tripledigit monthly distance total will help you get out the door in the morning before the chill sets in...",
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),*/

                         /* TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.orange,
                            labelColor: Colors.black,
                            tabs: const [
                              Tab(text: "Overall"),
                              Tab(text: "Following"),
                            ],
                          ),

                          /// Tab Content
                          SizedBox(
                            height: 400, // <-- fixed height for list
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _overAllList(),
                                _overAllList(),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox();
          },

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

  Widget _overAllList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey.shade100,
            child: const Row(
              children: [
                Expanded(flex: 1, child: Text("RANK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 3, child: Text("ATHLETE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 2, child: Text("DISTANCE", textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("${index + 1}")),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          SizedBox(height: 30, child: Image.asset(AppImageOthers.defaultUserImg)),
                          const SizedBox(width: 8),
                          const Text("Rajiv Malik", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text("153.72 km", textAlign: TextAlign.end, style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


}
Widget overAllStats(){
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            "Your Overall Stats",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing:25,
            childAspectRatio: 1.9,
            physics:  NeverScrollableScrollPhysics(),
            children:  [
              _StatItem(title: "Distance", value: "10.35 km"),
              _StatItem(title: "Moving Time", value: "14:05:19"),
              _StatItem(title: "Elevation Gain", value: "579 m"),
              _StatItem(title: "Elapsed Time", value: "14:05:19"),
            ],
          ),
        ],
      ),
    ),
  );
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


