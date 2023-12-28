import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/assets_manager.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/services/excel_store.dart';
import 'package:recovery_app/services/picture_upload_services.dart';

import '../../resources/color_manager.dart';

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
  String? imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("init state on profiel");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
          PopupMenuButton<int>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<int>>[
                // PopupMenuItem(
                //     child: Row(
                //   children: [
                //     SvgPicture.asset(IconAssets.kyc_ic),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     const Text("Add Kyc Picture"),
                //   ],
                // )),
                // PopupMenuItem(
                //     child: Row(
                //   children: [
                //     SvgPicture.asset(IconAssets.acTransaction_ic),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     const Text("Account Transaction"),
                //   ],
                // )),
                PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        SvgPicture.asset(IconAssets.idCard_ic),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Download id Card"),
                      ],
                    )),
                PopupMenuItem(
                    value: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        log("on tap on logot");
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    IconAssets.logout_ic,
                                    height: 100,
                                  ),
                                ),
                                Text(
                                  "Oh no! You are leaving... \n are you sure?",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(5),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text("Nah, Just Kidding",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (c) => Login()),
                                      (route) => false,
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(5),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue, width: 1.0)),
                                    child: Text("Yes, Log me out",
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(IconAssets.logout_ic),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("LogOut"),
                        ],
                      ),
                    )),
              ];
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                          minRadius: 50,
                          backgroundImage: NetworkImage(
                            imageUrl ??
                                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60",
                          )),
                      Positioned(
                        bottom: 10,
                        right: 125,
                        child: IconButton(
                          onPressed: () {
                            PictureUploadService.getImageFile(
                              context,
                              (url) {
                                setState(() {
                                  imageUrl = url;
                                });
                              },
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.pencil_circle_fill,
                            color: Colors.greenAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Text(
                  "Cameron Williamson",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "cameronwilliamson@gmail.com",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        fontSize: 15),
                  ),
                ),
              ],
            )),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getRow(
                  title: "First Name",
                  textEditingController: _firstNameController),
              _getRow(
                  title: "Last Name",
                  textEditingController: _lastNameController),
              _getRow(
                  title: "Mobile Number",
                  textEditingController: _mobNoController),
              Row(
                children: [
                  Flexible(
                      child: _getRow(
                          title: "State",
                          textEditingController: _stateController)),
                  const SizedBox(width: 20),
                  Flexible(
                      child: _getRow(
                          title: "Pin Code",
                          textEditingController: _pinCodeController)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: _getRow(
                          title: "District",
                          textEditingController: _stateController)),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: _getRow(
                          title: "Village",
                          textEditingController: _pinCodeController)),
                ],
              ),
              _getRow(
                  title: "Address", textEditingController: _addressController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRow({
    required String title,
    required TextEditingController textEditingController,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: false,
            controller: textEditingController,
            decoration: InputDecoration(
              label: Text(title),
              labelStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
              border: const UnderlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }
}
