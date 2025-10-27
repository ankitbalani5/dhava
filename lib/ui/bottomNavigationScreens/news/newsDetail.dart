import 'package:coherent_endurance/bloc/newsDetailBloc/news_detail_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../resources/image/appImages.dart';

class NewsDetail extends StatefulWidget {
  String newsId;

  NewsDetail({required this.newsId, super.key});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final List<Map<String, dynamic>> newsList = [
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": "2 Mins Ago",
      "image": "https://picsum.photos/400/200?1", // dummy image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": null,
      "image": null, // no image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": null,
      "image": null, // no image
    },
    {
      "title": "Start Your Healthy Life Today!",
      "description":
      "Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now! Kickstart Your Journey To Wellness With Simple, Sustainable Habits Now!",
      "time": "10 Mins Ago",
      "image": "https://picsum.photos/400/200?2",
    },

  ];

  @override
  void initState() {
    context.read<NewsDetailBloc>().add(
        FetchNewsDetailEvent(context: context, newsId: widget.newsId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackButtonWidget()),
        title: Text('News', style: CustomTextStyles.bold()),
      ),
      body: BlocConsumer<NewsDetailBloc, NewsDetailState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          if(state is NewsDetailLoading){
            return Center(
              child: Constant.loadingAnimation(),
            );
          }
          if(state is NewsDetailSuccess){
            var newsData = state.newsDetailModel.data;

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
                    /// अगर image है तो show करो
              
                    CachedNetworkImage(
                      imageUrl: newsData?.image ?? '',
                      // Replace with your back icon path
                      width: MediaQuery.of(context).size.width,
                      // height: 120,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Image.asset(AppImageOthers.newsBanner),
                      errorWidget: (context, url, error) => Image.asset(AppImageOthers.newsBanner),
                    ),
                    // if (news["image"] != null)
                    //   ClipRRect(
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Image.network(
                    //       news["image"],
                    //       height: 125,
                    //       width: double.infinity,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    const SizedBox(height: 8),
              
                    /// Title + Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(newsData!.title.toString(),
                                style: CustomTextStyles.bold(fontSize: 12))),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text(Constant.formatDob(newsData.newsDatetime.toString()),
                                  style: CustomTextStyles.medium(
                                      fontSize: 10)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
              
                    /// Description
                    Text(newsData.description.toString(),
                        style: CustomTextStyles.regular(
                            fontSize: 14, textColor: Colors.black)),
                  ],
                ),
              ),
            );
          }
          if(state is NewsDetailError){
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
