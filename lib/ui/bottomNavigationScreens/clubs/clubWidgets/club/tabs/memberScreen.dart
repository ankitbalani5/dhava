import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:flutter/material.dart';

import 'memberTab/adminTab.dart';
import 'memberTab/everyoneTab.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()
        ),
        title: Text('Members', style: CustomTextStyles.bold(),),
      ),
      body: Column(
        children: [
          Expanded(child: MemberTabWidget())
        ],
      ),
    );
  }
}



class MemberTabWidget extends StatefulWidget {
  MemberTabWidget({super.key});

  @override
  State<MemberTabWidget> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTabWidget>
    with TickerProviderStateMixin {
  late TabController controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {
        _selectedIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TabBar(
            controller: controller,
            labelColor: AppColor.bgRed,
            unselectedLabelColor: Colors.black54,
            indicatorColor: AppColor.bgRed,
            tabs: [
              Tab(
                child:  Text("Everyone", style: CustomTextStyles.bold(textColor: _selectedIndex == 0
                    ? AppColor.bgRed
                    : Colors.black,fontSize: 12)),
              ),
              Tab(
                child:   Text("Admin", style: CustomTextStyles.bold(textColor: _selectedIndex == 1
                    ? AppColor.bgRed
                    : Colors.black,fontSize: 14)),
              ),

            ],
          ),

          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                EveryoneTab(),
                AdminTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
