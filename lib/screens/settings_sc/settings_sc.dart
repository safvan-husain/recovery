import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/color_manager.dart';

class SettingsScView extends StatefulWidget {
  const SettingsScView({super.key});

  @override
  State<SettingsScView> createState() => _SettingsScViewState();
}

class _SettingsScViewState extends State<SettingsScView> {
  List<String> _languageList() => ["English", "Arabic", "Spanish"];
  int _selectedIndex = 0;

  bool _uos = false;
  bool _lvtc = false;
  bool _hvn = false;
  bool _kfts = false;
  bool _sts = false;

  @override
  Widget build(BuildContext context) {
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
          "Settings",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                // _getRowUOS(value: _uos),
                // _getRowLVTC(value: _lvtc),
                // _getRowHVN(value: _hvn),
                // _getRowKFTS(value: _kfts),
                // _getRowSTS(value: _sts),
                InkWell(
                    onTap: () {
                      // PersistentNavBarNavigator.pushNewScreen(
                      //   context,
                      //   screen: LanguageScView(),
                      //   withNavBar: true, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation:
                      //       PageTransitionAnimation.cupertino,
                      // );
                    },
                    child: _getRow(title: "Update Data")),
                _getRow(title: "Terms and Conditions"),
                InkWell(onTap: () {}, child: _getRow(title: "Privacy Policy")),
              ],
            )),
      ),
    );
  }

  Widget _getRowUOS({required bool value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Using Offline Search",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: _uos == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: (value) => setState(() => _uos = value),
          ),
        ],
      ),
    );
  }

  Widget _getRowLVTC({required bool value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "List of vehicles in two columns",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: _lvtc == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: (value) => setState(() => _lvtc = value),
          ),
        ],
      ),
    );
  }

  Widget _getRowHVN({required bool value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hyphenated Vehicle No",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: _hvn == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: (value) => setState(() => _hvn = value),
          ),
        ],
      ),
    );
  }

  Widget _getRowKFTS({required bool value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Keep Filter Term On Search",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: _kfts == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: (value) => setState(() => _kfts = value),
          ),
        ],
      ),
    );
  }

  Widget _getRowSTS({required bool value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Scroll Top On Search",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: _sts == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: (value) => setState(() => _sts = value),
          ),
        ],
      ),
    );
  }

  Widget _getRow({required String title}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(color: ColorManager.grey, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: ColorManager.primary,
          )
        ],
      ),
    );
  }
}
