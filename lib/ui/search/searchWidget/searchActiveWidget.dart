import 'package:coherent_endurance/models/findUserModel.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profileScreens/otherProfileScreen.dart';
import '../searchBloc/search_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/image/appImages.dart';
import '../../../resources/color/appColor.dart';
import '../searchBloc/search_state.dart';

class SearchActiveWidget extends StatefulWidget {
  const SearchActiveWidget({Key? key}) : super(key: key);

  @override
  State<SearchActiveWidget> createState() => _SearchActiveWidgetState();
}

class _SearchActiveWidgetState extends State<SearchActiveWidget> {
  final TextEditingController _controller = TextEditingController();
  final RefreshController _refreshController = RefreshController(); // ✅
  List<String> searchResults = [];

  int _page = 1; // pagination page
  List<InnerData> _users = []; // सभी users store करने के लिए

  void _onChanged(String query) {
    if (query.isNotEmpty) {
      _page = 1; // जब नया search करें तो page reset
      _users.clear();
      context.read<SearchCubit>().searchUsers(query, context, perPage: 10, page: _page);
    }
  }

  void _onLoading() {
    if (_controller.text.isNotEmpty) {
      _page++;
      context.read<SearchCubit>().searchUsers(_controller.text, context, perPage: 10, page: _page);
    }
  }
  // void _onChanged(String query) {
  //   if(query.isNotEmpty){
  //     context.read<SearchCubit>().searchUsers(query, context, perPage: 10, page: 1,);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => context.read<SearchCubit>().deactivateSearch(),
      //   ),
      //   title: const Text(
      //     "Search",
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: SmartRefresher(
        controller: _refreshController, // ✅ controller assign
        enablePullDown: false,
        enablePullUp: true, // ✅ नीचे scroll करने पर loadMore enable
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: 50,),
                TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hintText: "Search on Coherent",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            if(_controller.text.isEmpty){
                              context.read<SearchCubit>().deactivateSearch();
                            }else{
                              _controller.clear();
                              _onChanged('');
                            }
                          },
                          child: SvgPicture.asset('assets/image/svg/searchCancel.svg', height: 30)),
                      // child: SvgPicture.asset(AppImageSvg.searchRed, height: 30),
                    ),
                    filled: true,
                    fillColor: AppColor.bgTextField,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<SearchCubit, SearchState>(
                  listener: (context, state) {
                    if (state is SearchLoaded) {
                      if (_page == 1) {
                        _users = state.users; // fresh data
                      } else {
                        _users.addAll(state.users); // add more data
                      }
          
                      // अगर data कम आया तो और load disable कर दो
                      if (state.users.length < 10) {
                        _refreshController.loadNoData();
                      } else {
                        _refreshController.loadComplete();
                      }
                      setState(() {}); // UI refresh
                    } else if (state is SearchError) {
                      _refreshController.loadFailed();
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchInitial || _controller.text.isEmpty) {
                      return const Center(child: Text("Start typing to search..."));
                    } else if (state is SearchLoading && _page == 1) {
                      return Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: AppColor.bgRed,
                          size: 20,
                        ),
                      );
                    } else if (_users.isEmpty) {
                      return const Center(child: Text("No results found"));
                    }
          
                    return ListView.builder(
                      itemCount: _users.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return ListTile(
                          leading: Image.asset(AppImageOthers.userDp, height: 38),
                          title: Text(
                            '${user.firstName ?? 'Unknown'} ${user.lastName ?? ''}',
                            style: CustomTextStyles.semiBold(fontSize: 14),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.location ?? 'Unknown location',
                                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              const Text('Local Legend near you',
                                  style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                          trailing: Container(
                            height: 35,
                            width: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColor.bgRed),
                            ),
                            child: Center(
                              child: Text(
                                'Follow',
                                style: TextStyle(color: AppColor.bgRed, fontSize: 14),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtherProfileScreen(path: user.userId.toString()),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
          
                // Expanded(
                //   child: BlocBuilder<SearchCubit, SearchState>(
                //     builder: (context, state) {
                //       if (state is SearchInitial || _controller.text.isEmpty) {
                //         return const Center(
                //           child: Text("Start typing to search..."),
                //         );
                //       } else if (state is SearchLoading) {
                //         return Center(
                //           child: LoadingAnimationWidget.inkDrop(
                //             color: AppColor.bgRed,
                //             size: 20,
                //           ),
                //         );
                //       } else if (state is SearchLoaded) {
                //         if (state.users.isEmpty) {
                //           return const Center(
                //             child: Text("No results found"),
                //           );
                //         }
                //         return ListView.builder(
                //           itemCount: state.users.length,
                //           itemBuilder: (context, index) {
                //             final user = state.users[index];
                //             return ListTile(
                //               contentPadding: EdgeInsets.zero,
                //               leading:
                //               Image.asset(
                //                 AppImageOthers.userDp,
                //                 height: 38,
                //               ),
                //               title: Text(
                //                 '${user.firstName ?? 'Unknown'} ${user.lastName ?? ''}' ?? "Unknown",
                //                 style: CustomTextStyles.semiBold(fontSize: 14),
                //               ),
                //               subtitle: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     user.location ?? 'Unknown location',
                //                     style: const TextStyle(
                //                         color: Colors.grey, fontSize: 11),
                //                   ),
                //                   const Text(
                //                     'Local Legend near you',
                //                     style: TextStyle(
                //                         color: Colors.grey, fontSize: 11),
                //                   ),
                //                 ],
                //               ),
                //               trailing: Container(
                //                 height: 35,
                //                 width: 85,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(20),
                //                   border: Border.all(color: AppColor.bgRed),
                //                 ),
                //                 child: Center(
                //                   child: Text(
                //                     'Follow',
                //                     style: TextStyle(
                //                       color: AppColor.bgRed,
                //                       fontSize: 14,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               onTap: () {
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) =>
                //                         OtherProfileScreen(path: user.userId.toString()),
                //                   ),
                //                 );
                //               },
                //             );
                //           },
                //         );
                //       } else if (state is SearchError) {
                //         return Center(
                //           child: Text(state.message),
                //         );
                //       }
                //       return const SizedBox.shrink();
                //     },
                //   ),
                //   // ListView.builder(
                //   //   itemCount: searchResults.length,
                //   //   itemBuilder: (context, index) => GestureDetector(
                //   //     onTap: () {
                //   //       Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(path: '',)));
                //   //     },
                //   //     child: ListTile(
                //   //       contentPadding: EdgeInsets.zero,
                //   //       leading: Image.asset(AppImageOthers.userDp, height: 38,)/*const Icon(Icons.search)*/,
                //   //       title: Text(searchResults[index], style: CustomTextStyles.semiBold(fontSize: 14),),
                //   //       subtitle: Column(
                //   //         crossAxisAlignment: CrossAxisAlignment.start,
                //   //         children: [
                //   //           Text('jaipur, Rajasthan', style: TextStyle(color: Colors.grey, fontSize: 11),),
                //   //           Text('Local Legend near you', style: TextStyle(color: Colors.grey, fontSize: 11)),
                //   //         ],
                //   //       ),
                //   //       trailing:
                //   //       Container(
                //   //         height: 35,
                //   //         width: 85,
                //   //         decoration: BoxDecoration(
                //   //             borderRadius: BorderRadius.circular(20),
                //   //             // color: AppColor.bgRed
                //   //           border: Border.all(color: AppColor.bgRed)
                //   //         ),
                //   //         child: Center(
                //   //           child: Text('Follow', style: TextStyle(color: AppColor.bgRed, fontSize: 14),),
                //   //         ),
                //   //       ),
                //   //     ),
                //   //   ),
                //   // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
