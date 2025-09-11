import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:flutter/material.dart';

import '../../resources/style/textStyle.dart';
import '../../widgets/backButton.dart';

class DataPermission extends StatefulWidget {
  const DataPermission({super.key});

  @override
  State<DataPermission> createState() => _DataPermissionState();
}

class _DataPermissionState extends State<DataPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()),
        title: Text('Data Permissions', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Coherent Endurance collects and uses health data from"
                " paired devices, like a heart rate monitor, to give you"
                " interesting and useful performance analysis. We collect"
                " this data only from sensors or devices you've connected"
                " to Coherent Endurance."
                " We do not share it without your consent.", style: CustomTextStyles.regular(fontSize: 14),),
            SizedBox(height: 35,),
            GestureDetector(
              onTap: () {
                showHealthDialog(context);
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Health-Related Data', style: CustomTextStyles.semiBold(fontSize: 14),),
                    Text("Select one", style: CustomTextStyles.regular(fontSize: 14),),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> showHealthDialog(BuildContext context) async {
    String? selectedValue = "Allow"; // default selection

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Access to Health-Related Data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Allow"),
                    value: "Allow",
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Decline"),
                    value: "Decline",
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "If you decline, your Strava activities will no longer "
                        "include heart rate or other health-related data.",
                    style: CustomTextStyles.regular(fontSize: 14)
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
              child: Text("Cancel", style: CustomTextStyles.regular(fontSize: 18, textColor: AppColor.bgRed)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedValue);
              },
              child: Text("Ok", style: CustomTextStyles.regular(fontSize: 18, textColor: AppColor.bgRed)),
            ),
          ],
        );
      },
    );
  }

}
