import 'package:flutter/material.dart';
import 'package:recovery_app/Login/login.dart';
import 'package:recovery_app/Logo/logo.dart';
import 'package:recovery_app/add_record_sc/add_record_sc.dart';
import 'package:recovery_app/app_users_sc/app_users_sc.dart';
import 'package:recovery_app/blacklist_sc/black_list_sc.dart';
import 'package:recovery_app/catagories_sc/categories_sc.dart';
import 'package:recovery_app/category_list_sc/category_list_sc.dart';
import 'package:recovery_app/finances/finances_sc.dart';
import 'package:recovery_app/language_sc/language_sc.dart';
import 'package:recovery_app/otp_list_sc/otp_list_sc.dart';
import 'package:recovery_app/prepare_report/prepare_report.dart';
import 'package:recovery_app/profile_sc/profile_disp_sc.dart';
import 'package:recovery_app/profile_sc/profile_sc.dart';
import 'package:recovery_app/settings_sc/settings_sc.dart';
import 'package:recovery_app/vehical_info_sc/vehical_info_confirm.dart';
import 'package:recovery_app/vehical_info_sc/vehical_info_sc.dart';

import '../resources/route_manager.dart';
import '../resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  //const MyApp({super.key});
  // MyApp._internal();  //Private Named Constructor
  // int appState = 0;
  // static final MyApp instance = MyApp._internal();  //Single Instance -- Singleton
  // factory MyApp() =>instance; //factory for class Instance
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // getSharedData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     home: VehicalInfoConfirmView());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
     // initialRoute: Routes.bottomNav,
      theme: getApplicationTheme(),
      routes: {
        '/': (context) => const Logo(),
        '/login': (context) => const Login(),
      },
    );
  }
}
