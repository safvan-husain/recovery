import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recovery_app/bottom_navigation/bottom_navigation_page.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:recovery_app/screens/authentication/unapproved_screen.dart';
import 'package:recovery_app/storage/user_storage.dart';
import 'package:uuid/uuid.dart';

class AuthServices {
  static final Dio dio = Dio();

  static Future<void> loginUser({
    required String userName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    print("logi n user ");
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/loginapi.php",
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        print(response.data);
        var user = UserModel.fromServerJson2(response.data);
        await Storage.storeUser(user);
        if (context.mounted) {
          context.read<HomeCubit>().setUser(user);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ),
            (s) => false,
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
          "Failed to connect to the server",
          context,
          Icons.warning,
        );
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getAgencyList() async {
    List<Map<String, dynamic>> list = [];
    try {
      var response = await dio.get(
        "https://www.recovery.starkinsolutions.com/listagency.php",
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.data);
        for (var element in res) {
          list.add(element);
        }
        print(res);
        // return res;
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  static Future<(String? otp, UserModel? user)> verifyPhone({
    required String phone,
    required BuildContext context,
    bool isLogin = true,
  }) async {
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/smsapi.php",
        data: jsonEncode({"phone_number": phone}),
      );
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.data);
        if (result['status'] == true) {
          if (result.containsKey("details")) {
            var user = UserModel.fromServerJson(result);
            if (isLogin) {
              if (context.mounted) context.read<HomeCubit>().setUser(user);
              await Storage.storeUser(user);
            }

            return ("${result["otp"]}", user);
          }
          return ("${result["otp"]}", null);
        } else {
          if (context.mounted) {
            showSnackbar("failed to send otp", context, Icons.warning);
            throw Error();
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return (null, null);
  }

  static Future<void> registerUser({
    required String userName,
    required String email,
    required String password,
    required String address,
    required BuildContext context,
    required File panCard,
    required File adharCard,
    required String agencyId,
    required String phone,
  }) async {
    try {
      var response = await dio.post(
        "https://www.recovery.starkinsolutions.com/registerapi.php",
        data: {
          "phone_number": phone,
          "name": userName,
          "email": email,
          "password": password,
          "address": address,
          "agencyid": int.parse(agencyId)
        },
      );
      print(response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result['status'] == true) {
          try {
            FormData formData = FormData();
            String fileName = panCard.path.split('/').last;
            formData.files.add(
              MapEntry(
                'image1', // Use a unique key for each image
                await MultipartFile.fromFile(
                  panCard.path,
                  filename: fileName,
                ),
              ),
            );
            String adharFileName = adharCard.path.split('/').last;
            formData.files.add(
              MapEntry(
                'image2', // Use a unique key for each image
                await MultipartFile.fromFile(
                  adharCard.path,
                  filename: adharFileName,
                ),
              ),
            );
            formData.fields.add(MapEntry('agentName', userName));

            Response re = await dio.post(
              'https://www.recovery.starkinsolutions.com/addImage.php',
              data: formData,
              options: Options(
                headers: {'Content-Type': 'multipart/form-data'},
              ),
            );
            if (result['status'] == true) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnApprovedScreen()),
                  (s) => false,
                );
              }
            } else {
              print(re.data);
            }
          } catch (e) {
            print(e);
          }
        } else {
          if (context.mounted) {
            showSnackbar(result['message'], context, Icons.warning);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void uploadProfilePicture(File picture, String email) async {
    try {
      FormData formData = FormData();

      String adharFileName = picture.path.split('/').last;
      formData.files.add(
        MapEntry(
          'image2', // Use a unique key for each image
          await MultipartFile.fromFile(
            picture.path,
            filename: adharFileName,
          ),
        ),
      );
      formData.fields.add(MapEntry('email', email));

      Response re = await dio.post(
        'https://www.recovery.starkinsolutions.com/add_profile.php',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
