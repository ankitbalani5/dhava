import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditClubProfile extends StatefulWidget {
  const EditClubProfile({super.key});

  @override
  State<EditClubProfile> createState() => _EditClubProfileState();
}

class _EditClubProfileState extends State<EditClubProfile> {
  final TextEditingController titleController = TextEditingController(text: "We Runners Club");
  final TextEditingController descriptionController = TextEditingController(text: "We Runners: Our vision is to bring as many runners as we can to connect with We Runners and expand our running club.\n\nOur mission is to make people aware of their health.");
  final TextEditingController locationController = TextEditingController(text: "Jaipur, Rajasthan");
  final TextEditingController vanityController =
  TextEditingController(text: "werunnersclub");

  final List<String> sports = ["Running", "Cycling", "Swimming"];
  final List<String> clubTypes = ["Employee group", "Open group", "Private"];
  String selectedSport = "Running";
  String selectedClubType = "Employee group";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImageOthers.clubDetailBanner),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                left: 15,
                right: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            height: 30,
                            child: Image.asset(AppImageOthers.backArrow),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "Club",
                          style: CustomTextStyles.bold(
                              textColor: Colors.white, fontSize: 18, ),
                        ),
                      ],
                    ),
                    
                    Text(
                      "Edit Club",
                      style: CustomTextStyles.bold(textColor: Colors.white, fontSize: 18,),),

                    Text(
                      "Save",
                      style: CustomTextStyles.bold(
                          textColor: Colors.white, fontSize: 18,),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  child: Image.asset(AppImageOthers.clubDP),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "We Runners Club",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
           SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  _label("Club Title",""),
                  _textField(titleController),

                  _label("Sport",""),
                  _dropdown(selectedSport, sports,(value) {setState(() => selectedSport = value!);},icon: AppImageSvg.run
                  ),

                  _label("Club Type",""),
                  _dropdown(selectedClubType, clubTypes, (value) {
                    setState(() => selectedClubType = value!);
                  }),
                   Padding(
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select up to 3",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                  ),


                  _label("Description",""),
                  _multilineTextField(descriptionController),

                  _label("Location","Optional"),
                  _textField(locationController, showClear: true),

                  _label("Vanity URL","Optional"),
                  _textField(vanityController),
                   Padding(
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "strava.com/club/werunnersclub",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                  ),

                   SizedBox(height: 40),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget _label(String text,String Optional) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style:  TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(Optional,
                style:  TextStyle(fontSize: 12,
                    fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, {bool showClear = false}) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.bgTile,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: showClear
              ? IconButton(
            icon:  Icon(Icons.close, size: 18),
            onPressed: () => controller.clear(),
          )
              : null,
        ),
      ),
    );
  }

  Widget _multilineTextField(TextEditingController controller) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          filled: true,
          fillColor:AppColor.bgTile,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
      String selected,
      List<String> items,
      ValueChanged<String?> onChanged, {
        String? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: selected,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.bgTile,
          prefixIcon: icon != null
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: Colors.black,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }


}



