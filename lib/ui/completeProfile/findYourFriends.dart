
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_event.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_bloc.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_state.dart';
import 'package:coherent_endurance/models/suggestionsModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/completeProfile/step9Screen.dart';
import 'package:coherent_endurance/ui/profileScreens/otherProfileScreen.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_cubit.dart';
import 'package:coherent_endurance/ui/search/searchScreen.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/constant.dart';
import 'createProfile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class FindYourFriends extends StatefulWidget {
  const FindYourFriends({super.key});

  @override
  State<FindYourFriends> createState() => _FindYourFriendsState();
}

class _FindYourFriendsState extends State<FindYourFriends> {
  final TextEditingController _controller = TextEditingController();
  List<String> searchResults = [];

  final List<Map<String, String>> suggestedPeople = List.generate(
    7,
        (index) => {
      "name": "Rajiv Malik",
      "location": "Jaipur, Rajasthan",
      "status": "Local Legend near you",
      "image": "assets/image/others/userDp.png",
    },
  );

  void _onChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchResults = List.generate(8, (index) => "$query");
      });
    } else {
      setState(() {
        searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Image.asset(AppImageOthers.findYourFriendBanner),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(AppImageOthers.findYourFriendBanner),
                    const SizedBox(height: 10),
                    Text(
                      "It's not always a solo sport.",
                      style: CustomTextStyles.semiBold(
                        fontSize: 16,
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Add friends on Coherent Endurance to give and receive kudos, share encouragement and spark your motivation.',
                      style: CustomTextStyles.regular(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Find your friends on Dhava',
                      style: CustomTextStyles.bold(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()))
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.bgTextField,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Search on Coherent', style: TextStyle(color: Colors.grey)),
                              SvgPicture.asset(AppImageSvg.searchRed)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Suggested Follows',
                      style: CustomTextStyles.bold(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildSuggestedList(context)
                    /// Suggested People List
              /*      ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: suggestedPeople.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    person["location"]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    person["status"]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Follow",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CustomButton(
          text: 'Continue',
          color: AppColor.bgRed,
          textColor: Colors.white,
          callback: () {

            FocusScope.of(context).unfocus();
            (context.findAncestorStateOfType<CreateProfileState>())
                ?.addOverlay(Step9Screen());
          },
        ),
      ),
    );
  }


  Widget _buildSuggestedList(BuildContext context) {
    return BlocConsumer<SuggestionBloc, SuggestionState>(
      listener: (context, state) {
        if (state is SuggestionError) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is UnfollowError) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is UnfollowSuccess) {
          Fluttertoast.showToast(msg: "Unfollowed successfully");
        }
      },
      builder: (context, state) {
        if (state is SuggestionLoading) {
          return Center(
            child: LoadingAnimationWidget.inkDrop(
              color: AppColor.bgRed,
              size: 20,
            ),
          );
        }


        if (state is SuggestionSuccess) {
          var suggestedList = state.suggestionModel.data?.data ?? [];


          return  suggestedList.isEmpty ? Center(child: Text("No suggestions available")) :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "People You May Know",
                style: CustomTextStyles.regular(fontSize: 12),
              ),
              SizedBox(height: 10),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestedList.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final person = suggestedList[index];
                  var userId = person.userId.toString();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OtherProfileScreen(userId: userId),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: person.profilePhoto != null &&
                              person.profilePhoto!.isNotEmpty
                              ? NetworkImage(person.profilePhoto!)
                              : AssetImage(AppImageOthers.defaultUserImg)
                          as ImageProvider,
                          onBackgroundImageError: (_, __) {
                            debugPrint("Failed to load user image");
                          },
                        ),
                        SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${person.firstName ?? ''} ${person.lastName ?? ''}",
                                style:  TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (person.location != null &&
                                  person.location!.isNotEmpty)
                                Text(
                                  person.location!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              /// ---- FOLLOW ----
                              if (person.isFollowed == false && person.isFollowRequested == false) {
                                person.isFollowRequested = true;
                                context.read<FollowRequestBloc>().add(
                                  FollowRequestDataEvent(
                                    context: context,
                                    toUserId: person.userId.toString(),
                                  ),
                                );
                              }

                              /// ---- CANCEL REQUEST ----
                              else if (person.isFollowRequested == true) {
                                person.isFollowRequested = false;
                                context.read<FollowRequestBloc>().add(
                                  FollowRequestDataEvent(
                                    context: context,
                                    toUserId: person.userId.toString(),
                                  ),
                                );
                                // TODO: cancel follow request API if available
                              }


                            });
                          },
                          child: Container(
                            height: 35,
                            width: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: person.isFollowed == true
                                    ? Colors.green
                                    : person.isFollowRequested == true
                                    ? Colors.grey
                                    : AppColor.bgRed,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                person.isFollowRequested == true
                                    ? "Requested"
                                    : "Follow",
                                style: TextStyle(
                                  color: person.isFollowed == true
                                      ? Colors.green
                                      : person.isFollowRequested == true
                                      ? Colors.grey
                                      : AppColor.bgRed,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// Invite Friends Button
              Padding(
                padding:  EdgeInsets.all(5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Invite Friends',

                    callback: () async {
                      final packageName = await Constant.loadPackageName();
                      final link = "https://play.google.com/store/apps/details?id=$packageName";
                      Share.share(
                        "Check out my profile on Dhava 🏃‍♂️:\n$link",
                        subject: "My Profile",
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return SizedBox();

      },
    );
  }
}
