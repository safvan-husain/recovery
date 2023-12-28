import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/BottomNav/bottom_nav.dart';
import 'package:recovery_app/screens/authentication/agency_code_screen.dart';
import 'package:dio/dio.dart';

class AuthServices {
  static final Dio dio = Dio();

  static Future<void> loginUser({
    required String userName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/loginapi.php",
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        try {
          var re = await dio.post(
            "https://www.recovery.starkinsolutions.com/protectedpage.php",
            data: response.data,
          );
          if (re.statusCode == 200) {
            if (context.mounted) {
              showSnackbar(
                "Welcome back user",
                context,
                FontAwesomeIcons.thumbsUp,
                Colors.greenAccent,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavView()),
              );
            }
          } else {
            if (context.mounted) {
              showSnackbar(
                "Got non-200 status code",
                context,
                Icons.warning,
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            showSnackbar(
              "failed to get response from the server",
              context,
              Icons.warning,
            );
          }
        }
      } else {
        if (context.mounted) {
          showSnackbar(
            "Got non-200 status code",
            context,
            Icons.warning,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar(
          "Failed to connect to the server",
          context,
          Icons.warning,
        );
      }
    }
  }

  static Future<String?> verifyPhone({
    required String phone,
    required BuildContext context,
  }) async {
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/smsapi.php",
        data: {"phone_number": "8766865573"},
      );
      print(response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result['status'] == true) {
          return result["otp"];
        } else {
          if (context.mounted) {
            showSnackbar("failed to send otp", context, Icons.warning);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> registerUser({
    required String userName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/smsapi.php",
        data: {"phone_number": "8766865573"},
      );
      print(response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result['status'] == true) {
          return result["otp"];
        } else {
          if (context.mounted) {
            showSnackbar("failed to send otp", context, Icons.warning);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
