// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/screens/vehical_info_sc/vehical_info_confirm.dart';
import 'package:recovery_app/services/excel_store.dart';
import 'package:recovery_app/services/loation.dart';

import '../../models/otp_model.dart';
import '../../resources/color_manager.dart';

class VehicalInfoView extends StatefulWidget {
  final DetailsModel detailsModel;
  const VehicalInfoView({
    Key? key,
    required this.detailsModel,
  }) : super(key: key);

  @override
  State<VehicalInfoView> createState() => _VehicalInfoViewState();
}

class _VehicalInfoViewState extends State<VehicalInfoView> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "Vehical Information",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(80),
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //     // padding: EdgeInsets.symmetric(horizontal: 10),
        //     height: 40, width: scWidth,
        //     decoration: BoxDecoration(
        //       // border: Border.all(color: Colors.black,width: 1,strokeAlign: BorderSide.strokeAlignOutside),
        //       // color: Colors.red,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: SearchBar(
        //       backgroundColor:
        //           MaterialStatePropertyAll(ColorManager.searchBarBackColor),
        //       elevation: const MaterialStatePropertyAll(0),
        //       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10))),
        //       // controller: _searchBarController,
        //       hintText: "Search",
        //       hintStyle: MaterialStatePropertyAll(
        //           TextStyle(color: ColorManager.white)),
        //       leading: IconButton(
        //           onPressed: () {},
        //           icon: Icon(
        //             Icons.search,
        //             color: ColorManager.white,
        //           )),
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(color: ColorManager.grey.withOpacity(00.2)),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Column(
                    children: widget.detailsModel
                        .toMap()
                        .entries
                        .map((e) => _getInfoTile(
                            title: e.key, value: e.value.toString()))
                        .toList(),
                  ),
                  // _getTextField(
                  //     controller: _vehicalAddrController,
                  //     hintText: "Vehical Address"),
                  // _getTextField(
                  //     controller: _goodsController, hintText: "Carries Goods"),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showAlertDialog(context);
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: const VehicalInfoConfirmView(),
                        //   withNavBar: true, // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation:
                        //       PageTransitionAnimation.cupertino,
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          alignment: Alignment.center),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Send Confirm",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.1,
                            textAlign: TextAlign.center,
                          )))
                ],
              ),
            )),
      ),
    );
  }

  Widget _getTextField(
      {required TextEditingController controller, required String hintText}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  Row _getInfoTile({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      formatString(title),
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    ":",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            )),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value,
              maxLines: null,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

String formatString(String input) {
  String result = '';
  for (int i = 0; i < input.length; i++) {
    if (input[i] == '_') {
      result += ' ';
    } else if (i != 0 &&
        input[i - 1] != ' ' &&
        input[i].toUpperCase() == input[i] &&
        input[i - 1].toUpperCase() != input[i - 1]) {
      result += ' ' + input[i];
    } else {
      result += input[i];
    }
  }
  return result[0].toUpperCase() + result.substring(1);
}

void showAlertDialog(BuildContext context) {
  TextEditingController customController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Write a short note'),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Send'),
            onPressed: () {
              Navigator.of(context).pop();
              LocationService.share();
              // You can use the input from the TextField here
              print(customController.text.toString());
            },
          ),
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
