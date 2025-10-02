
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_cubit.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget buildFriendsTab(TabController innerTabController, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text('Find Your Friends On Coherent', style: CustomTextStyles.bold(fontSize: 16),),
            SizedBox(height: 10,),
            // Search Box
            GestureDetector(
              onTap: () => context.read<SearchCubit>().activateSearch(),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.bgTextField,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Search on Coherent', style: TextStyle(color: Colors.grey),),
                      SvgPicture.asset(AppImageSvg.searchRed)
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      Container(
        color: AppColor.bgTile,
        child: TabBar(
          controller: innerTabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.red,
          dividerColor: Colors.transparent,
          labelStyle: CustomTextStyles.semiBold(fontSize: 18),
          tabs: const [
            Tab(text: "Suggested"),
            Tab(text: "Contacts"),
          ],
        ),
      ),
      const SizedBox(height: 15),

      // Suggested People
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TabBarView(
            controller: innerTabController,
            children: [
              _buildSuggestedList(),
              // const Center(child: Text("Contacts Coming Soon...")),
              _buildContactsTab(),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildSuggestedList() {
  final List<Map<String, String>> suggestedPeople = List.generate(
    7,
        (index) => {
      "name": "Rajiv Malik",
      "location": "Jaipur, Rajasthan",
      "status": "Local Legend near you",
      "image": "assets/image/others/userDp.png",
    },
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "People You May Know",
        style: CustomTextStyles.regular(fontSize: 12),
      ),
      const SizedBox(height: 10),

      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: suggestedPeople.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final person = suggestedPeople[index];
            return Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(person["image"]!),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person["name"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        person["location"]!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        person["status"]!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    "Follow",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Invite Friends',
            callback: () {
              // Invite Friends Logic
            },
          ),
        ),
      ),
    ],
  );
}

Widget _buildContactsTab() {
  return Center(
    child: Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImageSvg.contact),
              SizedBox(height: 10,),
              Text('Connect Contacts', style: CustomTextStyles.regular(),),
              Text("Your friends are on Strava, See what they're\n"
                  "up to by connecting your phone contacts.", textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Container(
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.bgRed)
                ),
                child: Center(
                  child: Text('Connect Securely', style: CustomTextStyles.regular(textColor: AppColor.bgRed),),
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Invite Friends',
              callback: () {
                // Invite Friends Logic
              },
            ),
          ),
        ),
      ],
    ),
  );
}
