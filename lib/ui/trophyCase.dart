import 'package:coherent_endurance/bloc/trophyBloc/trophy_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/milestone.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

import '../models/trophyModel.dart';


class TrophyCase extends StatefulWidget {
  String categoryId;
  TrophyCase({required this.categoryId, super.key});

  @override
  State<TrophyCase> createState() => _TrophyCaseState();
}

class _TrophyCaseState extends State<TrophyCase> {
  List<Map<String, String>> milestone = [
    {"image": AppImageOthers.milestone, "title": "10th Activity"},
    {"image": AppImageOthers.milestone, "title": "100th Activity"},
    {"image": AppImageOthers.milestone, "title": "150th Activity"},
    {"image": AppImageOthers.milestone, "title": "200th Activity"},
    {"image": AppImageOthers.milestone, "title": "300th Activity"},
    {"image": AppImageOthers.milestone, "title": "400th Activity"},
  ];
  List<Map<String, String>> badges = [
    {"image": AppImageOthers.badge, "title": "December 5K", "subTitle": 'Dec 2021'},
    {"image": AppImageOthers.badge, "title": "December 5K", "subTitle": 'Dec 2021'},
    {"image": AppImageOthers.badge, "title": "December 5K", "subTitle": 'Dec 2021'},
  ];

  @override
  void initState() {
    context.read<TrophyBloc>().add(MyTrophyEvent(context: context, page: '1', perPage: '10', categoryId: widget.categoryId));
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
            child: BackButtonWidget()
        ),
        title: Text('TrophyCase', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: BlocConsumer<TrophyBloc, TrophyState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            if(state is MyTrophyLoading){
              return Center(child: Constant.loadingAnimation());
            }
            if(state is MyTrophySuccess){
              var trophyData = state.trophyModel.data?.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text('Milestone', style: CustomTextStyles.bold(fontSize: 16),),
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                        //     },
                        //     child: Text('View All', style: CustomTextStyles.regular(fontSize: 16))),
                      ],
                    ),
                    SizedBox(height: 10,),
                    buildBadgeGrid(trophyData),


                    // SizedBox(height: 30,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('2025', style: CustomTextStyles.bold(fontSize: 16),),
                    //     GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                    //         },
                    //         child: Text('3', style: CustomTextStyles.regular(fontSize: 16))),
                    //   ],
                    // ),
                    //
                    //
                    // buildBadgeGrid(badges),
                    // SizedBox(height: 30,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('2023', style: CustomTextStyles.bold(fontSize: 16),),
                    //     GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => MilestoneScreen()));
                    //         },
                    //         child: Text('3', style: CustomTextStyles.regular(fontSize: 16))),
                    //   ],
                    // ),
                    //
                    //
                    // buildBadgeGrid(badges),

                  ],
                ),
              );
            }
            if(state is MyTrophyError){
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

  Widget buildBadgeGrid(List<TrophyModelData>? badges) {
    List<Widget> rows = [];

    for (int i = 0; i < badges!.length; i += 3) {
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
            children: rowItems.map((badge) {
              return Column(
                children: [
                  Image.network(
                    (badge.trophyIcon != null && badge.trophyIcon!.isNotEmpty)
                        ? badge.trophyIcon!
                        : '',
                    height: 70,
                    width: 65,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImageOthers.milestone,
                        height: 75,
                        width: 70,
                      );
                    },
                  ),

                  // Image.network(
                  //   badge.trophyIcon.toString(),
                  //   height: 75, width: 70,
                  // ),
                  SizedBox(height: 8),
                  Text(
                    badge.title!,
                    style: CustomTextStyles.semiBold(fontSize: 12),
                  ),

                  // if (badge["subTitle"] != null && badge["subTitle"]!.isNotEmpty)
                  // Text(
                  //     badge['subTitle']!,
                  //   style: CustomTextStyles.regular(fontSize: 12),
                  // )
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

}
