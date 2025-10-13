
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Endurance extends StatefulWidget {
  const Endurance({super.key});

  @override
  State<Endurance> createState() => _EnduranceState();
}

class _EnduranceState extends State<Endurance> {
  int selectedIndex = 1;

  String categoryId = '';
  String categoryName = '';
  String categoryIcon = '';
  final List<String> icons = [
    AppImageSvg.walk,
    AppImageSvg.run,
    AppImageSvg.cycle
  ];

  final List<String> backgroundImages = [
    AppImageOthers.runEndurance,
    AppImageOthers.cycleEndurance,
    AppImageOthers.walkingImg,
  ];

  List<String?> bgImg = [];
  // final List<String> backgroundImages = [
  //   AppImageOthers.runEndurance,
  //   AppImageOthers.cycleEndurance,
  //   AppImageOthers.walkingImg,
  // ];

  @override
  void initState() {

    print('current State from endurance:::${bottomNavKey.currentState?.currentTap}');
    final defaultCategory = Constant.getCategory?.data?.firstWhere(
          (e) => e.categoryName?.toLowerCase() == "walk",
      // orElse: () => Constant.getCategory?.data.first,
    );

    bgImg = Constant.getCategory!.data!.map((e) => e.backgroundImage).toList();

    categoryId = defaultCategory!.categoryId!;
    categoryName = defaultCategory!.categoryName!;
    categoryIcon = defaultCategory!.categoryIcon!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bottomNavKey.currentState?.changeTab(0);
        return false; // prevent BottomNavBar onWillPop from firing immediately
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          title: Text(
            'Endurance',
            style: CustomTextStyles.bold(fontSize: 18),
          ),
        ),
        body: Stack(

          children: [

            Container(color: Colors.white),

            Positioned.fill(

              top: 50,
              child: CachedNetworkImage(
                imageUrl: bgImg[selectedIndex].toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: AppColor.bgRed,
                    strokeWidth: 1,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(AppImageOthers.profilePic, fit: BoxFit.cover,color: Colors.white,),
              ),
            ),

            // 🔹 Gradient overlay (optional)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),



            // 🔹 Rest of your UI
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  Constant.getCategory!.data!.length,
                      (index) {
                    final isSelected = selectedIndex == index;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              categoryId = Constant.getCategory!.data![index].categoryId.toString();
                              categoryName = Constant.getCategory!.data![index].categoryName.toString();
                              categoryIcon = Constant.getCategory!.data![index].categoryIcon.toString();
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColor.bgRed : Colors.black,
                              ),
                              color: isSelected ? AppColor.bgRed : Colors.white,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    Constant.getCategory!.data![index].categoryIcon.toString(),
                                    height: 20,
                                    width: 20,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    Constant.getCategory!.data![index].categoryName.toString(),
                                    style: TextStyle(
                                      color: !isSelected ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 🔹 Bottom Start Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    'Get Started With Your\nHealth Goals',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.semiBold(
                      fontSize: 26,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(bottomNavKey.currentContext!).push(
                        MaterialPageRoute(
                          builder: (_) => TrackingScreen(categoryId, categoryName, categoryIcon),
                        ),
                      );
                    },

                    child: Container(
                      width: 260,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.bgRed,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              'Start',
                              style: CustomTextStyles.bold(textColor: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )



        /*Stack(
          children: [
            Container(color: Colors.white),

            Positioned(
              top: 50,
              child: CachedNetworkImage(
                imageUrl:  bgImg[selectedIndex].toString(),
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
                placeholder:
                    (context, url) =>
                    Padding(
                      padding:
                      EdgeInsets.all(40.0),
                      child:
                      CircularProgressIndicator(
                        color: AppColor.bgRed,
                        strokeWidth: 1,
                      ),
                    ),
                errorWidget: (context,
                    url, error) =>
                    Image.asset(AppImageOthers.profilePic, height: 90,),
              ),

            ),


            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),


            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(

                    Constant.getCategory!.data!.length,
                        (index) {
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            categoryId = Constant.getCategory!.data![index].categoryId.toString();
                          });
                        },
                        child: Container(
                          width: 110,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? AppColor.bgRed : Colors.black),
                            color: isSelected ? AppColor.bgRed : Colors.white
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Image.network(Constant.getCategory!.data![index].categoryIcon.toString() , height: 20, width: 20, color: isSelected ? Colors.white : Colors.black,),
                                SizedBox(width: 10,),
                                Text(Constant.getCategory!.data![index].categoryName.toString(), style: TextStyle(color: !isSelected ? Colors.black : Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  );
                }),
              ),
            ),


            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text('Get Started With Your\nHealth Goals',
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.semiBold(fontSize: 26, textColor: Colors.white)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingScreen(categoryId)));
                    },
                    child: Container(
                      width: 260,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.bgRed
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text('Start', style: CustomTextStyles.bold(textColor: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}
