
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/progressHistory.dart';
import 'package:coherent_endurance/ui/bottomNavigationScreens/record/trackingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Endurance extends StatefulWidget {
  const Endurance({super.key});

  @override
  State<Endurance> createState() => _EnduranceState();
}

class _EnduranceState extends State<Endurance> {
  int selectedIndex = 1; // Default: Run

  String categoryId = '';
  final List<String> icons = [
    AppImageSvg.walk,
    AppImageSvg.run,
    AppImageSvg.cycle
  ];

  // 🔁 Corresponding images for each mode
  final List<String> backgroundImages = [
    AppImageOthers.walkEndurance, // 👈 create this asset
    AppImageOthers.runEndurance,
    AppImageOthers.cycleEndurance, // 👈 create this asset
  ];

  @override
  void initState() {

    final defaultCategory = Constant.getCategory?.data?.firstWhere(
          (e) => e.categoryName?.toLowerCase() == "walk",
      // orElse: () => Constant.getCategory?.data.first, // fallback पहला element
    );

    categoryId = defaultCategory!.categoryId!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: Container(
        //   margin: const EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30), color: Colors.white24),
        //   child: const Center(
        //       child: Padding(
        //         padding: EdgeInsets.only(left: 8.0),
        //         child: Icon(Icons.arrow_back_ios, color: Colors.black),
        //       )),
        // ),
        title: Text(
          'Endurance',
          style: CustomTextStyles.bold(fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.white),

          /// 🔁 Background Image according to selectedIndex
          Positioned(
            top: 50,
            child: Image.asset(
              backgroundImages[selectedIndex],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

          /// Gradient overlay
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

          /// Activity Selector Buttons
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
                return Padding(
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
                            // Icon(icons[index] , color: !isSelected ? Colors.black : Colors.white,),
                            Image.network(Constant.getCategory!.data![index].categoryIcon.toString() , height: 20, width: 20, color: isSelected ? Colors.white : Colors.black,),
                            SizedBox(width: 10,),
                            Text(Constant.getCategory!.data![index].categoryName.toString(), style: TextStyle(color: !isSelected ? Colors.black : Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  )
                  /*ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected ? AppColor.bgRed : Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                            isSelected ? Colors.transparent : Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(icons[index], size: 20 , color: !isSelected ? Colors.black : Colors.white,),
                    label: Text(labels[index], style: TextStyle(color: !isSelected ? Colors.black : Colors.white),),

                  ),*/
                );
              }),
            ),
          ),

          /// Bottom Text and Button
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
                /*ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressScreen()));
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: Text('Start', style: CustomTextStyles.bold(textColor: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bgRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
