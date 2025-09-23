import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {

  @override
  void initState() {
    super.initState();
    _showActionSheet(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton.filled(
          child:  Text("Show Dialog"),
          onPressed: () => _showActionSheet(context),
        ),
      ),
    );
  }



  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);

              print("Make Admin Clicked");
            },
            child:  Text(
              "Make Admin",
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              print("Remove Clicked");
            },
            child:  Text("Remove"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            print("Cancel Clicked");
          },
          child:  Text(
            "Cancel",
            style: TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
      ),
    );
  }
}


