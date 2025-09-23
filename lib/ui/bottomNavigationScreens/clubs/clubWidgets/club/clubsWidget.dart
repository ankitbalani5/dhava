
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/clubs/clubWidgets/club/createAClub.dart';
import 'package:coherent_endurance/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'clubDetailScreen.dart';
import 'package:coherent_endurance/constant/constant.dart';


class Club {
  final String name;
  final String location;
  final String members;
  final String posts;
  final String image;

  Club({
    required this.name,
    required this.location,
    required this.members,
    required this.posts,
    required this.image,
  });
}


final List<Club> clubs = [
  Club(
    name: "We Runners Club",
    location: "Jaipur, Rajasthan, India",
    members: "564 Members",
    posts: "140 Post",
    image: AppImageOthers.clubDP,
  ),
  Club(
    name: "Pinkcity Runners",
    location: "Delhi, India",
    members: "2,091 Members",
    posts: "95 Post",
    image: AppImageOthers.pcrImg,
  ),

];


Widget clubsWidget({
  required BuildContext context,
  required bool isJoinClub,
  required Function(dynamic value) onJoinClub,
}) {
  return isJoinClub ? joinedClubsWidget2(context) : initialClubWidget(onJoinClub: onJoinClub,context: context);
}

Widget initialClubWidget({required Function(dynamic value) onJoinClub,required BuildContext context}) {


  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(AppImageOthers.clubBanner),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your own coherent endurance club',
                style: CustomTextStyles.semiBold(fontSize: 16),
              ),
              Text(
                'Give your community a motivating home base on coherent endurance.',
                style: CustomTextStyles.regular(
                    fontSize: 11, textColor: Colors.grey),
              ),
              SizedBox(height: 10),
              CustomButton(
                text: 'Get started',
                callback: () {},
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImageOthers.location, height: 30, width: 30),
                  SizedBox(width: 10),
                  Text(
                    'Popular clubs near you',
                    style: CustomTextStyles.medium(fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailScreen
                    ()
                  )
                  );
                },
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                      mainAxisExtent: 220
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:  EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:  Color(0xFFF2F2F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppImageOthers.clubDP, height: 55,),
                          SizedBox(height: 5),
                          Text('Pinkcity Runners', style: CustomTextStyles.semiBold(fontSize: 15),),
                          Row(
                            children: [
                              SvgPicture.asset(AppImageSvg.run, color: Colors.black,),
                              SizedBox(width: 5,),
                              Text('545 Runners', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.black87),),
                            ],
                          ),
                          Text('Jaipur, Rajasthan, India', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.black87),),
                          SizedBox(height: 8,),
                          Spacer(),
                          Center(
                            child: SizedBox(
                              height: 35,
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.bgRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:  EdgeInsets.symmetric(vertical: 2),
                                ),
                                onPressed: () {
                                  onJoinClub (true);
                                },
                                child: Text("Join", style: CustomTextStyles.bold(textColor: Colors.white, fontSize: 13),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget joinedClubsWidget2(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create your own coherent endurance club',
            style: CustomTextStyles.semiBold(fontSize: 16)),
        Text(
          'Give your community a motivating home base on coherent endurance.',
          style: CustomTextStyles.regular(fontSize: 11, textColor: Colors.grey),
        ),
        SizedBox(height: 10),
        CustomButton(
          text: 'Create a Club',
          callback: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAClub()));
          },
        ),
        SizedBox(height: 10),

        Expanded(
          child: GestureDetector(
            onTap: (){

            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailScreen()));
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F0),
                    borderRadius: BorderRadius.circular(12),
                    //border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Image.asset(clubs[index].image, height: 55),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Club Name
                            Text(
                              clubs[index].name,
                              style: CustomTextStyles.semiBold(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                SvgPicture.asset(AppImageSvg.run,
                                    color: Colors.black, height: 16),
                                SizedBox(width: 5),
                                Text(
                                  clubs[index].members,
                                  style: CustomTextStyles.regular(
                                      fontSize: 12, textColor: Colors.black87),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  clubs[index].location,
                                  style: CustomTextStyles.regular(
                                      fontSize: 12, textColor: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  clubs[index].posts,
                                  style: CustomTextStyles.regular(
                                      fontSize: 12, textColor: Colors.black87),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Evening Weight Training",
                                  style: CustomTextStyles.semiBold(fontSize: 15,textColor: AppColor.bgRed),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward_ios_outlined, size: 18,color: AppColor.bgRed,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )

      ],
    ),
  );
}

























