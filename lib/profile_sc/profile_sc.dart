import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recovery_app/resources/assets_manager.dart';

import '../resources/color_manager.dart';

class ProfileScView extends StatefulWidget {
  const ProfileScView({super.key});

  @override
  State<ProfileScView> createState() => _ProfileScViewState();
}

class _ProfileScViewState extends State<ProfileScView> {
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
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem>[
                PopupMenuItem(child: Container(child: Row(
                  children: [
                    SvgPicture.asset(IconAssets.kyc_ic),
                    SizedBox(width: 10,),
                    Text("Add Kyc Picture"),
                  ],
                ),)),
                PopupMenuItem(child: Container(child:Row(
                  children: [
                    SvgPicture.asset(IconAssets.acTransaction_ic),
                    SizedBox(width: 10,),
                    Text("Account Transaction"),
                  ],
                ),)),
                PopupMenuItem(child: Container(child:Row(
                  children: [
                    SvgPicture.asset(IconAssets.idCard_ic),
                    SizedBox(width: 10,),
                    Text("Download id Card"),
                  ],
                ),)),
                PopupMenuItem(child: Container(child: Row(
                  children: [
                    SvgPicture.asset(IconAssets.logout_ic),
                    SizedBox(width: 10,),
                    Text("LogOut"),
                  ],
                ),)),
              ];
            },
            icon: SvgPicture.asset(IconAssets.menu_ic),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              child:  Column(
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
                        Positioned(
                          bottom: 10,right: 125,
                          child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.pencil_circle_fill,color: Colors.greenAccent,),),)
                      ],
                    ),
                  ),
                  Text(
                    "Cameron Williamson",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "cameronwilliamson@gmail.com",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 15),
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
              children: [
                _getRow(title: "First Name", textEditingController: _firstNameController),
                _getRow(title: "Last Name", textEditingController: _lastNameController),
                _getRow(title: "Mobile Number", textEditingController: _mobNoController),
                Row(children: [
                  Flexible(child: _getRow(title: "State", textEditingController: _stateController)),
                  SizedBox(width: 20,),
                  Flexible(child: _getRow(title: "Pin Code", textEditingController: _pinCodeController)),
                ],),
                Row(children: [
                  Flexible(child: _getRow(title: "District", textEditingController: _stateController)),
                  SizedBox(width: 20,),
                  Flexible(child: _getRow(title: "Village", textEditingController: _pinCodeController)),
                ],),
                _getRow(title: "Address", textEditingController: _addressController),
              ],
            )),
      ),
    );
  }

  Widget _getRow({required String title, required TextEditingController textEditingController}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //     border: BorderDirectional(
      //         bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          ),
         TextField(
            decoration: InputDecoration(suffixIcon: Icon(CupertinoIcons.pencil),),
           controller: textEditingController,
         )
        ],
      ),
    );
  }
}
