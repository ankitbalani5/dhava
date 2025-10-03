import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> listEfforts = [
    {"distance": "5 mile", "time": "13:55", "speed": "43.1 km/h"},
    {"distance": "10 K", "time": "13:55", "speed": "43.1 km/h"},
    {"distance": "10 mile", "time": "25:22", "speed": "38.1 km/h"},
    {"distance": "20 K", "time": "20:22", "speed": "38.3 km/h"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Result', style: CustomTextStyles.bold()),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Best Efforts",
                      style: CustomTextStyles.semiBold(
                        textColor: AppColor.lightGreyImageBackground,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "4",
                      style: CustomTextStyles.semiBold(
                        textColor: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Segments",
                      style: CustomTextStyles.semiBold(
                        textColor: AppColor.lightGreyImageBackground,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "5",
                      style: CustomTextStyles.semiBold(
                        textColor: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Achievements",
                      style: CustomTextStyles.semiBold(
                        textColor: AppColor.lightGreyImageBackground,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "2",
                      style: CustomTextStyles.semiBold(
                        textColor: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 5, thickness: 2, color: AppColor.bgTextField),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Segments",
                  style: CustomTextStyles.semiBold(
                    textColor: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "2",
                  style: CustomTextStyles.semiBold(
                    textColor: AppColor.lightGreyImageBackground,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Image.asset(AppImageOthers.defaultUserImg),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to Living",
                          style: CustomTextStyles.semiBold(
                            textColor: AppColor.lightGreyImageBackground,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0.33 km",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "29s",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "41.3 km/h",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 70),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "otrofogonazo-->",
                          style: CustomTextStyles.semiBold(
                            textColor: AppColor.lightGreyImageBackground,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0.33 km",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "29s",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "41.3 km/h",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Image.asset(AppImageOthers.defaultUserImg),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to Living",
                          style: CustomTextStyles.semiBold(
                            textColor: AppColor.lightGreyImageBackground,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0.33 km",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "29s",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "41.3 km/h",
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Best Efforts",
                  style: CustomTextStyles.semiBold(
                    textColor: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "3",
                  style: CustomTextStyles.semiBold(
                    textColor: AppColor.lightGreyImageBackground,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: listEfforts.length,
              itemBuilder: (context, index) {
                return Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                            listEfforts[index]["distance"],
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.lightGreyImageBackground,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              listEfforts[index]["time"],
                              style: CustomTextStyles.semiBold(
                                textColor: AppColor.textBackgroundGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          listEfforts[index]["speed"],
                          style: CustomTextStyles.semiBold(
                            textColor: AppColor.textBackgroundGrey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
