import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

class ContactAccess extends StatefulWidget {
  const ContactAccess({super.key});

  @override
  State<ContactAccess> createState() => _ContactAccessState();
}

class _ContactAccessState extends State<ContactAccess> {
  bool sync = false;
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
        title: Text('Contacts Access', style: CustomTextStyles.bold(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("When permission is granted, Coherent Endurance stores"
                " and periodically syncs to your address book to make it"
                " easy for you to find your friends. If you choose to remove"
                " this access we will stop using your address book information"
                " to connect you with friends and suggest that you follow"
                " them on Coherent Endurance."
                " Removing access will not affect your Beacon settings.", style: CustomTextStyles.regular(fontSize: 14),),
            SizedBox(height: 35,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coherent Sync Enabled', style: CustomTextStyles.semiBold(fontSize: 14),),
                Checkbox(value: sync, onChanged: (value) {
                  sync = !sync;
                  setState(() {

                  });
                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}
