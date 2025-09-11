import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/settingScreens/changeEmail.dart';
import 'package:coherent_endurance/ui/settingScreens/contactAccess.dart';
import 'package:coherent_endurance/ui/settingScreens/dataPermission.dart';
import 'package:coherent_endurance/ui/settingScreens/emailNotification.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var pushNotification = false;
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
        title: Text('Settings', style: CustomTextStyles.bold(fontSize: 18),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColor.bgTile,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
              title: Text('Change Email', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
              title: Text('Push Notification', style: CustomTextStyles.regular(fontSize: 14)),
              // trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
              trailing: Switch(value: pushNotification, onChanged: (value) {

              },),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EmailNotification()));
              },
              title: Text('Email Notification', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactAccess()));
              },
              title: Text('Contacts', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DataPermission()));
              },
              title: Text('Data Permissions', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
              title: Text('Support', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
              title: Text('Legal', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
              title: Text('About', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              title: Text('Delete Your Account', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
            ListTile(
              onTap: () {
                showLogoutDialog(context);
              },
              title: Text('Logout', style: CustomTextStyles.regular(fontSize: 14)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ),
          ],
        ),
      ),
    );
  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Text
                const Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                          style: CustomTextStyles.regular(fontSize: 14, textColor: AppColor.bgRed)
                      ),
                    ),

                    // Log Out Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Add your logout logic here
                      },
                      child: Text(
                        "Log Out?",
                          style: CustomTextStyles.regular(fontSize: 14, textColor: AppColor.bgRed)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
