import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/color_manager.dart';

class CategoriesScView extends StatefulWidget {
  const CategoriesScView({super.key});

  @override
  State<CategoriesScView> createState() => _CategoriesScViewState();
}

class _CategoriesScViewState extends State<CategoriesScView> {
  TextEditingController _searchBarController = TextEditingController();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "Categories",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            width: scWidth,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black,width: 1,strokeAlign: BorderSide.strokeAlignOutside),
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchBar(
              backgroundColor:
                  MaterialStatePropertyAll(ColorManager.searchBarBackColor),
              elevation: MaterialStatePropertyAll(0),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              controller: _searchBarController,
              hintText: "Search",
              hintStyle: MaterialStatePropertyAll(
                  TextStyle(color: ColorManager.white)),
              leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: ColorManager.white,
                  )),
            ),
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              _getCategory(title: "induslnd bank", value: 12),
              _getCategory(title: "Adani Nagar", value: 3),
              _getCategory(title: "Volvo Finance", value: 19),
            ],
          )),
    );
  }

  Widget _getCategory({required String title, required int value}) {
    return InkWell(
      onTap: () {
        setState(() {
          // _selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ColorManager.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: ColorManager.grey.withOpacity(
                    0.3,
                  ),
                  offset: Offset(5, 5))
            ]),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.network(
            //   "https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGJpa2UlMjBwbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60",
            //   fit: BoxFit.fitHeight,
            // ),
            Text(
              "Bike",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
