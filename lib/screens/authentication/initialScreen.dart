import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null && userJson.isNotEmpty) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/otp-login');
      }
      //TODO: when user exist in shared pref.
    } else {
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/otp-login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/icons/logo.jpeg'),
      ),
    );
  }
}
