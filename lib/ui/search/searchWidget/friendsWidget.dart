
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_event.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_bloc.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_state.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/suggestionsModel.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/otherProfileScreen.dart';
import 'package:coherent_endurance/ui/search/searchBloc/search_cubit.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
class FriendsTabWidget extends StatefulWidget {
  final TabController innerTabController;

  const FriendsTabWidget({Key? key, required this.innerTabController}) : super(key: key);

  @override
  State<FriendsTabWidget> createState() => _FriendsTabWidgetState();
}

class _FriendsTabWidgetState extends State<FriendsTabWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: 10),
              Text(
                'Find your friends on Dhava',
                style: CustomTextStyles.bold(fontSize: 16),
              ),
               SizedBox(height: 10),
              GestureDetector(
                onTap: () => context.read<SearchCubit>().activateSearch(),
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
               SizedBox(height: 20),
            ],
          ),
        ),

        Container(
          color: AppColor.bgTile,
          child: TabBar(
            controller: widget.innerTabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.red,
            dividerColor: Colors.transparent,
            labelStyle: CustomTextStyles.semiBold(fontSize: 18),
            tabs:  [
              Tab(text: "Suggested"),
              Tab(text: "Contacts"),
            ],
          ),
        ),
         SizedBox(height: 15),
        // Suggested People
        Expanded(
          child: Container(
            padding:  EdgeInsets.symmetric(horizontal: 15),
            child: TabBarView(
              controller: widget.innerTabController,
              children: [
                _buildSuggestedList(context),
                ContactsTab(),
              ],
            ),
          ),
        ),
      ],
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
              Expanded(
                child: ListView.separated(
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


class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  List<Contact> _contacts = [];
  bool _loading = false;
  bool _connected = false;
  bool _initializing = true; // 👈 Add this flag to handle flicker issue

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyConnected();
  }

  /// Check if contacts were already synced before
  Future<void> _checkIfAlreadyConnected() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyConnected = prefs.getBool('contactsSynced') ?? false;

    if (alreadyConnected) {
      // 👇 Immediately mark as connected (no flicker)
      setState(() {
        _connected = true;
        _initializing = false;
      });

      // 👇 Fetch contacts silently
      _fetchContacts(autoFetch: true);
    } else {
      setState(() {
        _initializing = false;
      });
    }
  }

  /// Fetch contacts and update UI
  Future<void> _fetchContacts({bool autoFetch = false}) async {
    var status = await Permission.contacts.status;

    if (!status.isGranted && !autoFetch) {
      status = await Permission.contacts.request();
    }

    if (!status.isGranted) {
      if (mounted && !autoFetch) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission denied to read contacts")),
        );
      }
      return;
    }

    setState(() => _loading = true);

    try {
      final List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);

      if (!mounted) return;

      setState(() {
        _contacts = contacts;
        _connected = true;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('contactsSynced', true);
    } catch (e, st) {
      debugPrint("Error fetching contacts: $e");
      debugPrintStack(stackTrace: st);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load contacts: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildConnectView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.contacts, size: 60, color: Colors.red),
        const SizedBox(height: 10),
        const Text(
          "Connect Contacts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        const Text(
          "Your friends are on Strava. See what they're\nup to by connecting your phone contacts.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _fetchContacts(),
          child: Container(
            height: 40,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red),
            ),
            child: const Center(
              child: Text("Connect Securely", style: TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactList() {
    if (_loading) {
      return  Center(child:Constant.loadingAnimation());
    }

    if (_contacts.isEmpty) {
      return const Center(child: Text("No contacts found."));
    }

    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final name = contact.displayName;
        final number = contact.phones.isNotEmpty == true
            ? contact.phones.first.number
            : 'No number';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: const AssetImage(AppImageOthers.defaultUserImg),
          ),
          title: Text(
            name,
            style: CustomTextStyles.semiBold(fontSize: 12),
            maxLines: 1,
          ),
          subtitle: Text(number),
          trailing: GestureDetector(
            onTap: () async {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
              final packageName = await Constant.loadPackageName();
              final link = "https://play.google.com/store/apps/details?id=$packageName";

              Share.share(
                "Check out my profile on Dhava 🏃‍♂️:\n$link",
                subject: "My Profile",
              );

            },
            child: Container(
              height: 35,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.bgRed),
              ),
              child: Center(
                child: Text(
                  "Invite",
                  style: CustomTextStyles.semiBold(
                    textColor: AppColor.textBackgroundGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Handle initialization/loading before showing UI
    if (_initializing) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: _connected ? _buildContactList() : _buildConnectView(),
    );
  }
}



