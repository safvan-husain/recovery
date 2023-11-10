import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/color_manager.dart';

class FinanceScView extends StatefulWidget {
  const FinanceScView({super.key});

  @override
  State<FinanceScView> createState() => _FinanceScViewState();
}

class _FinanceScViewState extends State<FinanceScView> {
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
          "Finances",
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
        child: Column(children: [
          _getRow(title: "induslnd bank", value: 12),
          _getRow(title: "Adani Nagar", value: 3),
          _getRow(title: "Volvo Finance", value: 19),
        ],)
      ),
    );
  }

  Widget _getRow({required String title, required int value}) {
    return InkWell(
      onTap: () {
        setState(() {
          // _selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: BorderDirectional(bottom: BorderSide(color: ColorManager.grey,width: 0.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "$value",
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
