import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recovery_app/resources/assets_manager.dart';

import '../../resources/color_manager.dart';

class ProfileDispScView extends StatefulWidget {
  const ProfileDispScView({super.key});

  @override
  State<ProfileDispScView> createState() => _ProfileDispScViewState();
}

class _ProfileDispScViewState extends State<ProfileDispScView> {
  TextEditingController _searchBarController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobNoController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _villageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  int _selectedIndex = 0;
  bool _isActive = true;
  bool _isAdminRights = true;

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
          "Manage Seizer",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem>[
                PopupMenuItem(
                    child: Container(
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.kyc_ic),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Add Kyc Picture"),
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: Container(
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.acTransaction_ic),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Account Transaction"),
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: Container(
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.idCard_ic),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Download id Card"),
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: Container(
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.logout_ic),
                      SizedBox(
                        width: 10,
                      ),
                      Text("LogOut"),
                    ],
                  ),
                )),
              ];
            },
            icon: SvgPicture.asset(IconAssets.menu_ic),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                            minRadius: 50,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60",
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getRow(title: "Full Name", value: "Cameron", width: scWidth),
                _getRow(
                    title: "Mobile Number",
                    value: "(603) 555-0123",
                    width: scWidth),
                _getRow(
                    title: "Address",
                    value: "2118 Thornridge Cir. Syracuse, Connecticut",
                    width: scWidth),
                _getRow(
                    title: "Reg Device Id",
                    value: "0212025689",
                    width: scWidth),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            fillColor:
                                MaterialStatePropertyAll(ColorManager.primary),
                            checkColor: ColorManager.white,
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value!;
                              });
                            }),
                        Text(
                          "Active",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            fillColor:
                                MaterialStatePropertyAll(ColorManager.primary),
                            checkColor: ColorManager.white,
                            value: _isAdminRights,
                            onChanged: (value) {
                              setState(() {
                                _isAdminRights = value!;
                              });
                            }),
                        Text(
                          "Admin Rights",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Subscriptions",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2118 Thornridge Cir. Syracuse",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2118 Thornridge Cir. Syracuse",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2118 Thornridge Cir. Syracuse",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
              ],
            )),
      ),
    );
  }

  Widget _getRow(
      {required String title, required String value, required double width}) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            value,
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
