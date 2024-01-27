import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recovery_app/bottom_navigation/bottom_navigation_page.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/device_verify_screen.dart';
import 'package:recovery_app/screens/authentication/otp_login.dart';
import 'package:recovery_app/services/auth_services.dart';
import 'package:recovery_app/services/sim_services.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkUserExists();
  }

  void checkUserExists() async {
    var user = await Storage.getUser();

    if (user != null) {
      // if (await Utils.isConnected() && mounted) {
      //   //for updating deviceId on this device, to ensure after change this app should not work.
      //   var result = await AuthServices.verifyPhone(
      //       phone: user.number, context: context);
      //   if (result.$2 != null) {
      //     user.changeDeviceId(result.$2!.deviceId);
      //     await Storage.storeUser(user);
      //   }
      // }
      if (context.mounted) {
        context.read<HomeCubit>().setUser(user);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => const BottomNavigation()),
          (p) => false,
        );
      }
      if (!await user.verifyDevice()) {
        //TODO: this should BE big wsnfs.
        // if (context.mounted) {
        //   context.read<HomeCubit>().setUser(user);
        //   Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (c) => const BottomNavigation()),
        //     (p) => false,
        //   );
        // }
      } else {
        if (context.mounted) {
          context.read<HomeCubit>().setUser(user);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const DeviceVerifyScreen()),
            (p) => false,
          );
        }
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (c) => const OtpLogin()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Center(
        child: Image.asset('assets/icons/logo.jpeg'),
      ),
    );
  }
}
