import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';

class EveryoneTab extends StatefulWidget {
  const EveryoneTab({super.key});

  @override
  State<EveryoneTab> createState() => _EveryoneTabState();
}

class _EveryoneTabState extends State<EveryoneTab> {

  List<Map<String, dynamic>> users = List.generate(
    10,
        (index) => {
      "name": "Rajiv Malik",
      "location": "Jaipur, Rajasthan",
      "tagline": "Local Legend near you",
      "image": AppImageOthers.defaultUserImg,
      "isFollowing": index % 2 == 0,
    },
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColor.bgTile,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                child: Text("MEMBERS YOU FOLLOW",style: CustomTextStyles.bold(textColor: Colors.black,fontSize: 14),),

              ),
            ),
            Expanded(child: buildMemberList(context))
          ],
        ),
      ),
    );
  }
  Widget buildMemberList(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        var user = users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Image.asset(user["image"]),
          ),
          title: Text(user["name"], style:  TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user["location"]),
              Text(user["tagline"], style:  TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    user["isFollowing"] = !user["isFollowing"];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.bgRed),
                    borderRadius: BorderRadius.circular(20),
                    color: user["isFollowing"] ?  AppColor.bgRed : Colors.white,
                  ),
                  child: Text(
                    user["isFollowing"] ? "Following" : "Follow",
                    style: TextStyle(
                      color: user["isFollowing"] ? Colors.white :  AppColor.bgRed,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon:  Icon(Icons.more_horiz),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("More options for ${user["name"]}")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}



