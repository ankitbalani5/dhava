
import 'package:coherent_endurance/bloc/profileBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/followRequest_event.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_bloc.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_state.dart';
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
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Find Your Friends On Coherent',
                style: CustomTextStyles.bold(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Search Box
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Search on Coherent', style: TextStyle(color: Colors.grey)),
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
            controller: widget.innerTabController,
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

        List<UserData> suggestedList = [];
        if (state is SuggestionSuccess) {
          suggestedList = state.suggestionModel.data?.data ?? [];
        }

        if (suggestedList.isEmpty) {
          return const Center(child: Text("No suggestions available"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "People You May Know",
              style: CustomTextStyles.regular(fontSize: 12),
            ),
            const SizedBox(height: 10),

            /// ✅ ListView of Suggestions
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: suggestedList.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 15),
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
                        const SizedBox(width: 10),

                        /// User name + location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${person.firstName ?? ''} ${person.lastName ?? ''}",
                                style: const TextStyle(
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
      },
    );
  }

/*  Widget _buildContactsTab() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImageSvg.contact),
                const SizedBox(height: 10),
                Text('Connect Contacts', style: CustomTextStyles.regular()),
                const Text(
                  "Your friends are on Strava, See what they're\nup to by connecting your phone contacts.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.bgRed),
                  ),
                  child: Center(
                    child: Text(
                      'Connect Securely',
                      style: CustomTextStyles.regular(textColor: AppColor.bgRed),
                    ),
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
  }*/
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
  Future<void> _fetchContacts() async {
    // Step 1: Check and request permission
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission denied to read contacts")),
        );
      }
      return;
    }

    // Step 2: Start loading
    setState(() => _loading = true);

    try {
      // Step 3: Fetch contacts using flutter_contacts
      final List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);

      if (!mounted) return;

      setState(() {
        _contacts = contacts;
        _connected = true;
      });
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

  /// 🔹 Initial Connect View
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
          onTap: _fetchContacts,
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

  /// 🔹 Show Contacts List
  Widget _buildContactList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_contacts.isEmpty) {
      return const Center(child: Text("No contacts found."));
    }

    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final name = contact.displayName ?? 'Unknown';
        final number = contact.phones?.isNotEmpty == true
            ? contact.phones!.first.number
            : 'No number';

        return ListTile(
          leading: CircleAvatar(child:Image.asset(AppImageOthers.defaultUserImg)),
          title: Text(name,style: CustomTextStyles.semiBold(fontSize: 12),maxLines: 1,),
          subtitle: Text(number ?? ''),
          trailing: GestureDetector(
            onTap: (){

                debugPrint('Invite $name');

            },
            child: Container(
              height: 35,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColor.bgRed,
                ),
              ),
              child: Center(
                child: Text("Invite",
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
    return Center(
      child: _connected ? _buildContactList() : _buildConnectView(),
    );
  }
}
