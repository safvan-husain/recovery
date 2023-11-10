import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../models/model.dart';
import '../resources/color_manager.dart';
import '../vehical_info_sc/vehical_info_sc.dart';

class BlackListScView extends StatefulWidget {
  const BlackListScView({super.key});

  @override
  State<BlackListScView> createState() => _BlackListScViewState();
}

class _BlackListScViewState extends State<BlackListScView> {
  TextEditingController _searchBarController = TextEditingController();

  List<UserModel> userList() => [
    UserModel(name: "Marvin McKinney", number: "(702) 555-0122"),
    UserModel(name: "Marvin McKinney", number: "(702) 555-0122"),
    UserModel(name: "Marvin McKinney", number: "(702) 555-0122"),
    UserModel(name: "Marvin McKinney", number: "(702) 555-0122"),
    UserModel(name: "Marvin McKinney", number: "(702) 555-0122"),
  ];

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
        title: Text(
          "App Users",
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
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: userList().length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _getListTile(index: index);
            }),
      ),
    );
  }

  Widget _getListTile({required int index}) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VehicalInfoView(),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          // width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2), //New
                    blurRadius: 5.0,
                    offset: Offset(0, 10))
              ]),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60",
                ),
              ),
            ),
            title: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      userList()[index].name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    userList()[index].number,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            trailing:  Text(
              "12 Aug 23",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
          ),
      ),
    );
  }
}
