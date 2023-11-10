import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/HomePage/home_page.dart';
import 'package:recovery_app/control_panel/control_panel_sc.dart';
import 'package:recovery_app/profile_sc/profile_disp_sc.dart';
import 'package:recovery_app/profile_sc/profile_sc.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/settings_sc/settings_sc.dart';

import '../resources/assets_manager.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late PersistentTabController _controller;

  @override
  initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
      onItemSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const SettingsScView(),
      ControlPanelView(),
      const ProfileScView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          IconAssets.home_ic,
          colorFilter: _currentIndex == 0
              ? ColorFilter.mode(ColorManager.primary, BlendMode.srcATop)
              : ColorFilter.mode(Colors.black, BlendMode.srcATop),
        ),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          IconAssets.settings_ic,
          colorFilter: _currentIndex == 1
              ? ColorFilter.mode(ColorManager.primary, BlendMode.srcATop)
              : ColorFilter.mode(Colors.black, BlendMode.srcATop),
        ),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          IconAssets.control_panel_ic,
          colorFilter: _currentIndex == 2
              ? ColorFilter.mode(ColorManager.primary, BlendMode.srcATop)
              : ColorFilter.mode(Colors.black, BlendMode.srcATop),
        ),
        title: ("Control Panel"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          IconAssets.account_ic,
          colorFilter: _currentIndex == 3
              ? ColorFilter.mode(ColorManager.primary, BlendMode.srcATop)
              : ColorFilter.mode(Colors.black, BlendMode.srcATop),
        ),
        title: ("Account"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.black,
      ),
    ];
  }
}
