



import 'package:flutter/material.dart';
import 'package:recovery_app/HomePage/home_page.dart';
import 'package:recovery_app/main.dart';
import 'package:recovery_app/resources/strings_manager.dart';

import '../BottomNav/bottom_nav.dart';




class Routes {
  static const String home = "/home";
  static const String bottomNav = "/bottomNav";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) =>  HomePage());
      case Routes.bottomNav:
        return MaterialPageRoute(builder: (_) =>  BottomNavView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound),
        ),
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
