import 'package:coherent_endurance/bloc/newsBloc/news_bloc.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/news/newsDetail.dart';
import 'package:coherent_endurance/ui/notification/notificationScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../constant/Constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int page = 1;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _loadPage();
    super.initState();
  }

  _loadPage(){
    context.read<NewsBloc>().add(FetchNewsEvent(context: context, page: '1', perPage: '10'));
  }

  void _onRefresh() {
    page = 1;
    _loadPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;
    context.read<NewsBloc>().add(FetchNewsEvent(
        context: context,
        perPage: '10',
        page: page.toString(),
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
        automaticallyImplyLeading: false,

        title: Text('News', style: CustomTextStyles.bold(),),
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
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.notification,
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
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColor.bgRed)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: context.read<ProfileBloc>().profileModel?.data?.profilePhoto ?? '',
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset(AppImageOthers.defaultImage,width: 30,
                          height: 30,),
                        errorWidget: (context, url, error) => Image.asset(AppImageOthers.defaultImage,width: 30,
                          height: 30,),
                      )
                    ),
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
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if(state is NewsLoading){
              return Center(
                child: Constant.loadingAnimation(),
              );
            }
            if(state is NewsSuccess){
              return ListView.builder(
                itemCount: state.newsModel.data!.data?.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var newsData = state.newsModel.data!.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(newsId: newsData.newsId.toString(),)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: newsData.image ?? '',
                              // Replace with your back icon path
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(AppImageOthers.newsBanner),
                              errorWidget: (context, url, error) => Image.asset(AppImageOthers.newsBanner),
                            ),
                          ),
                          // Image.asset(AppImageOthers.newsBanner),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 260,
                                  child: Text(newsData.title.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles.bold(fontSize: 14),)),
                              // Row(
                              //   children: [
                              //     Text('Helpful', style: CustomTextStyles.medium(fontSize: 12, textColor: AppColor.bgRed),),
                              //     SizedBox(width: 5,),
                              //     Icon(Icons.thumb_up, color: Colors.black , size: 15,)
                              //   ],
                              // )
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if(state is NewsError){
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
}
