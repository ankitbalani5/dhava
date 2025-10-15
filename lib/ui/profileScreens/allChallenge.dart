import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:coherent_endurance/constant/constant.dart';
import '../../bloc/myAllChallengeBloc/my_all_challenge_bloc.dart';
import '../../models/categoryModel.dart';
import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/backButton.dart';
import '../bottomNavigationScreens/clubs/clubWidgets/active/challangesActive.dart';

class AllChallenge extends StatefulWidget {
  String userId;
  AllChallenge({this.userId = '', super.key});

  @override
  State<AllChallenge> createState() => _AllChallengeState();
}

class _AllChallengeState extends State<AllChallenge> {
  int page = 1;
  String categoryId = '';
  CategoryModel? categoryData;
  final RefreshController _refreshController = RefreshController();


  void _onRefresh() {
    page = 1;
    context.read<MyAllChallengeBloc>().add(MyAllChallengeEvent(context: context, perPage: '10', page: page.toString(),userId: widget.userId, categoryId: categoryId,));
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    context.read<MyAllChallengeBloc>().add(MyAllChallengeEvent(
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
      context.read<MyAllChallengeBloc>().add(MyAllChallengeEvent(perPage: '10', page: page.toString(),userId: widget.userId, categoryId: '', context: context));



    // categoryData = CategoryModel(
    //     data: [
    //       CategoryModelData(
    //           categoryId: '',
    //           categoryName: 'All',
    //           backgroundImage: '',
    //           categoryIcon: '',
    //           tips: '',
    //           uniqueCode: ''
    //       ),
    //       if (Constant.getCategory?.data != null)
    //         ...Constant.getCategory!.data!
    //     ]
    // );

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
        title: Text('All Challenges', style: CustomTextStyles.bold(),),
      ),
      body: BlocConsumer<MyAllChallengeBloc, MyAllChallengeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is MyAllChallengeLoading){
            return Center(child: Constant.loadingAnimation());
          }
          if(state is MyAllChallengeSuccess){
            var challenges = state.myAllChallengeModel.data!.data;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              itemCount: challenges?.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final duration = Constant.calculateChallengeDuration(
                  challenges![index].startDate,
                  challenges[index].endDate,
                );
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChallangesActiveScreen(challengeId: challenges[index].challengeId.toString(),)));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: (challenges![index].challengeIcon != null && challenges[index].challengeIcon != 'null' &&
                      challenges[index].challengeIcon!.isNotEmpty)
                      ? CachedNetworkImage(
                    imageUrl: challenges[index].challengeIcon!,
                    height: 50,
                    width: 50,
                    imageBuilder: (context, imageProvider) => ClipOval(
                      child: Image(
                        image: imageProvider,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    placeholder: (context, url) => ClipOval(
                      child: SvgPicture.asset(
                        AppImageSvg.activeUser,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipOval(
                      child: SvgPicture.asset(
                        AppImageSvg.activeUser,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : ClipOval(
                    child: SvgPicture.asset(
                      AppImageSvg.activeUser,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),

                  title: Text(challenges[index].title.toString()/*'Timeout Streaks Challenge\nJuly 2025'*/),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(challenges[index].categoryIcon.toString(), height: 15, color: Colors.grey,),
                          Text(' --/${duration['weeks']} weeks', style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      Text('${duration['daysLeft']} days left', style: TextStyle(color: Colors.grey))
                    ],
                  ),
                );
              },
            );
          }
          if(state is MyAllChallengeError){
            return Center(
              child: Text(state.error),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
