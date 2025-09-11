import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/profileScreens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../searchBloc/search_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/image/appImages.dart';
import '../../../resources/color/appColor.dart';

class SearchActiveWidget extends StatefulWidget {
  const SearchActiveWidget({Key? key}) : super(key: key);

  @override
  State<SearchActiveWidget> createState() => _SearchActiveWidgetState();
}

class _SearchActiveWidgetState extends State<SearchActiveWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> searchResults = [];

  void _onChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchResults =
            List.generate(8, (index) => "$query");
      });
    } else {
      setState(() {
        searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => context.read<SearchCubit>().deactivateSearch(),
      //   ),
      //   title: const Text(
      //     "Search",
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: "Search on Coherent",
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        _controller.clear();
                        _onChanged('');
                      },
                      child: SvgPicture.asset('assets/image/svg/searchCancel.svg', height: 30)),
                  // child: SvgPicture.asset(AppImageSvg.searchRed, height: 30),
                ),
                filled: true,
                fillColor: AppColor.bgTextField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(
                child: Text("Start typing to search..."),
              )
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(AppImageOthers.userDp, height: 38,)/*const Icon(Icons.search)*/,
                    title: Text(searchResults[index], style: CustomTextStyles.semiBold(fontSize: 14),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('jaipur, Rajasthan', style: TextStyle(color: Colors.grey, fontSize: 11),),
                        Text('Local Legend near you', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    trailing:
                    Container(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: AppColor.bgRed
                        border: Border.all(color: AppColor.bgRed)
                      ),
                      child: Center(
                        child: Text('Follow', style: TextStyle(color: AppColor.bgRed, fontSize: 14),),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
