import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class MapSetting extends StatefulWidget {
  const MapSetting({super.key});

  @override
  State<MapSetting> createState() => _MapSettingState();
}

class _MapSettingState extends State<MapSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget(arrowColor: Colors.white, backgroundColor: Colors.white24,)),
        title: Text('Settings', style: CustomTextStyles.bold(textColor: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 170,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Screen Lock',
                          style: CustomTextStyles.semiBold(
                            fontSize: 16, textColor: Colors.white
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('30 Sec',
                          style: CustomTextStyles.semiBold(
                              fontSize: 16, textColor: AppColor.primaryColor
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(AppImageOthers.mapLock, height: 77)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    height: 170,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto-Pause',
                          style: CustomTextStyles.semiBold(
                            fontSize: 16, textColor: Colors.white
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('on: Ride',
                          style: CustomTextStyles.semiBold(
                              fontSize: 16, textColor: AppColor.primaryColor
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(AppImageOthers.mapPause, height: 77,)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
