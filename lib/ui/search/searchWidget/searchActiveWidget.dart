import 'package:coherent_endurance/models/findUserModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/otherProfileScreen.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_cubit.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SearchActiveWidget extends StatefulWidget {
  const SearchActiveWidget({Key? key}) : super(key: key);

  @override
  State<SearchActiveWidget> createState() => _SearchActiveWidgetState();
}

class _SearchActiveWidgetState extends State<SearchActiveWidget> {
  final TextEditingController _controller = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  List<String> searchResults = [];

  int _page = 1;
  List<InnerData> _users = [];
  void _onChanged(String query) {
    if (query.isNotEmpty) {
      _page = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: false,
        enablePullUp: true,
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
                        _users = state.users;
                      } else {
                        _users.addAll(state.users);
                      }
          

                      if (state.users.length < 10) {
                        _refreshController.loadNoData();
                      } else {
                        _refreshController.loadComplete();
                      }
                      setState(() {});
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
