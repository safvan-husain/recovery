import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/add_record_sc/add_record_sc.dart';
import 'package:recovery_app/app_users_sc/app_users_sc.dart';
import 'package:recovery_app/blacklist_sc/black_list_sc.dart';
import 'package:recovery_app/finances/finances_sc.dart';
import 'package:recovery_app/otp_list_sc/otp_list_sc.dart';
import 'package:recovery_app/prepare_report/prepare_report.dart';
import 'package:recovery_app/resources/assets_manager.dart';

import '../resources/color_manager.dart';

class ControlPanelView extends StatefulWidget {
  ControlPanelView({super.key});

  @override
  State<ControlPanelView> createState() => _ControlPanelViewState();
}

class _ControlPanelViewState extends State<ControlPanelView> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Control Panel",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AppUsersScView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(
                      icon: IconAssets.app_users_ic, title: "App Users")),
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: FinanceScView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(
                      icon: IconAssets.finances_ic, title: "Finances")),
              InkWell(
                  onTap: () {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: FinanceScView(),
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    // );
                  },
                  child: _getListTile(
                      icon: IconAssets.details_views_ic,
                      title: "Details Views")),
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AddNewRecordScView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(
                      icon: IconAssets.add_records_ic, title: "Add Records")),
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: OtpListView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(icon: IconAssets.otp_ic, title: "OTP")),
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: PrepareReportView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(
                      icon: IconAssets.reports_ic, title: "Reports")),
              InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: BlackListScView(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: _getListTile(
                      icon: IconAssets.blacklist_ic, title: "Blacklist")),
              InkWell(
                  onTap: () {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: BlackListScView(),
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    // );
                  },
                  child: _getListTile(
                      icon: IconAssets.offline_records_ic,
                      title: "Offline Records")),
              _getListTile(icon: IconAssets.new_group_ic, title: "New Group"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListTile({required String icon, required String title}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: ColorManager.grey.withOpacity(0.5), width: 1))),
      child: ListTile(
        leading: SvgPicture.asset(icon),
        title: Text(
          "$title",
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.5,
        ),
        trailing: Icon(
          CupertinoIcons.right_chevron,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}
