
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/image/appImages.dart';
import '../../resources/style/textStyle.dart';


class DefaultScreen extends StatefulWidget {
  bool isToolBar;

  DefaultScreen({this.isToolBar = true, super.key});

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.isToolBar ? GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: SvgPicture.asset(
                      AppImageSvg.backArrow,
                      width: 25,
                      height: 25,
                    ),
                  ) : SizedBox(),
                  const SizedBox(width: 20),
                  Expanded(
                    child:  widget.isToolBar ? Text(
                      "Feature Coming Soon",
                      style: CustomTextStyles.bold(),
                    ) : SizedBox(),
                  ),
                ],
              ),
              Expanded(child: showBasicSection())
            ],
          )
        ),
      ),
    );
  }

  Widget showBasicSection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppImageSvg.appLogo),
        SizedBox(height: 10),
        Text(
          "Feature Available Soon",
          style: CustomTextStyles.bold(fontSize: 16),
        ),
      ],
    );
  }
}
