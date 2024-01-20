import 'dart:convert';
import 'dart:developer';

import 'package:recovery_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> storeUser(UserModel user) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("user", user.toJson());
  }

  static Future<void> logOutUser() async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("user", '');
  }

  static Future<UserModel?> getUser() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var jsonUser = sharedPreference.getString("user");
    if (jsonUser != null && jsonUser.isNotEmpty) {
      return UserModel.fromJson(jsonUser);
    }
    return null;
  }

  static Future<void> storeEndData(String data) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("date", data);
  }

  static Future<void> addEntryCount(int count) async {
    var sharedPreference = await SharedPreferences.getInstance();
    int? currentCunt = sharedPreference.getInt('count');
    if (currentCunt != null) {
      await sharedPreference.setInt("count", currentCunt + count);
    } else {
      await sharedPreference.setInt("count", count);
    }
  }

  static Future<void> addProcessedFileIndex(int count) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setInt("file", count);
  }

  static Future<int> getProcessedFileIndex() async {
    var sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getInt("file") ?? 0;
  }

  static Future<void> emptyEntryCount() async {
    print('empty entry count');
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setInt("count", 0);
    log(sharedPreference.getInt('count').toString());
  }

  static Future<void> setIsTwoColumSearch(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("twoColumSearch", value);
  }

  static Future<bool> getIsTwoColumnSearch() async {
    var sharedPreference = await SharedPreferences.getInstance();
    bool? isTwo = sharedPreference.getBool('twoColumSearch');
    if (isTwo == null) {
      await sharedPreference.setBool("twoColumSearch", true);
      return true;
    } else {
      return isTwo;
    }
  }

  static Future<int> getEntryCount() async {
    var sharedPreference = await SharedPreferences.getInstance();
    int? currentCunt = sharedPreference.getInt('count');
    return currentCunt ?? 0;
  }

  static Future<int?> getRemaingDays() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var date = sharedPreference.getString("date");
    if (date != null) {
      DateTime endDate = DateTime.parse(date);
      int daysRemaining = endDate.difference(DateTime.now()).inDays;
      return daysRemaining < 0 ? 0 : daysRemaining;
    }
    return null;
  }

  static Future<void> storeTitleMap(List<String> titles) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString('titles', jsonEncode(titles));
  }

  static Future<List<String>> getTitleMap() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var jsonTitles = sharedPreference.getString('titles');
    if (jsonTitles != null) {
      return jsonDecode(jsonTitles);
    } else {
      throw ('no titles found in sahared preference');
    }
  }
}
