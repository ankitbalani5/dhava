import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_cubit.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_state.dart';
import 'package:coherent_endurance/ui/search/searchWidget/friendsWidget.dart';
import 'package:coherent_endurance/ui/search/searchWidget/searchActiveWidget.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _innerTabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _innerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // ❌ Default UI सिर्फ़ SearchInitial पर दिखेगी
          if (state is SearchInitial) {
            return _buildDefaultSearchUI(context);
          }

          // ✅ बाकी सब states में SearchActiveWidget दिखे
          return const SearchActiveWidget();
        },
      ),
    );
  }


  Widget _buildDefaultSearchUI (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: BackButtonWidget(),
        // automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Search', style: CustomTextStyles.bold(),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NotificationScreen(),
                    //   ),
                    // );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.search,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NotificationScreen(),
                    //   ),
                    // );
                  },
                  child: SvgPicture.asset(
                    AppImageSvg.notification,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfileScreen(),
                    //   ),
                    // );
                  },
                  child: Image.asset(
                    AppImageOthers.defaultImage,
                    // Replace with your back icon path
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.red,
          dividerColor: Colors.transparent,
          labelStyle: CustomTextStyles.semiBold(fontSize: 18),
          tabs: const [
            Tab(text: "Friends"),
            Tab(text: "Clubs"),
          ],
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: const Text(
      //     "Search",
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.notifications_none, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //     CircleAvatar(
      //       radius: 16,
      //       backgroundImage: AssetImage("assets/images/user.png"), // Replace with your profile pic asset
      //     ),
      //     const SizedBox(width: 10),
      //   ],
      //   bottom: TabBar(
      //     controller: _tabController,
      //     labelColor: Colors.red,
      //     unselectedLabelColor: Colors.black,
      //     indicatorColor: Colors.red,
      //     tabs: const [
      //       Tab(text: "Friends"),
      //       Tab(text: "Clubs"),
      //     ],
      //   ),
      // ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildFriendsTab(_innerTabController, context),
          const Center(child: Text("Clubs Tab Coming Soon...")),
        ],
      ),
    );
  }

  Widget searchWidget() {
    return
      Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search on Coherent",
              // prefixIcon: const Icon(Icons.search),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppImageSvg.searchRed, height: 33,),
              ),
              /*IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward, color: Colors.red),
                  ),*/
              filled: true,
              fillColor: AppColor.bgTextField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

        ],
      );
  }
}
