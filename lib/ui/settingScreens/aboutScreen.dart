import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version; // e.g. 1.12
      buildNumber = info.buildNumber; // e.g. 12393974
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'About',
          style: CustomTextStyles.bold(),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About",
              style: CustomTextStyles.semiBold(
                  textColor: AppColor.lightGreyImageBackground),
            ),
            const SizedBox(height: 20),
            Text(
              "Version",
              style:
              CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),
            ),

            // 👇 Dynamically show app version here
            Text(
              appVersion.isNotEmpty
                  ? "Dhava Version $appVersion ($buildNumber)"
                  : "Loading version...",
              style:
              CustomTextStyles.regular(textColor: AppColor.backgroundGrey),
            ),

            const SizedBox(height: 20),
            Text(
              "Rate this app",
              style:
              CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),
            ),
            const SizedBox(height: 20),
            Text(
              "Maps on Dhava",
              style:
              CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),
            ),
            const SizedBox(height: 20),
            Divider(
              height: 20,
              thickness: 2,
              color: AppColor.bgTextField,
            ),
            const SizedBox(height: 20),
            Text(
              "About the Company",
              style: CustomTextStyles.semiBold(
                  textColor: AppColor.lightGreyImageBackground),
            ),
            const SizedBox(height: 20),
            Text(
              "About Dhava",
              style:
              CustomTextStyles.semiBold(textColor: AppColor.backgroundGrey),
            ),
          ],
        ),
      ),
    );
  }
}
