
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/ui/completeProfile/step9Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/color/appColor.dart';
import '../../resources/style/textStyle.dart';
import '../../widgets/customButton.dart';
import 'createProfile.dart';

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
                      'Find Your Friends On Coherent',
                      style: CustomTextStyles.bold(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        hintText: "Search on Coherent",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppImageSvg.searchRed,
                            height: 33,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColor.bgTextField,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Suggested Follows',
                      style: CustomTextStyles.bold(fontSize: 18),
                    ),
                    const SizedBox(height: 10),

                    /// Suggested People List
                    ListView.separated(
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
                    ),
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
}
