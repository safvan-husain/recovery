import 'package:recovery_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> storeUser(UserModel user) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("user", user.toJson());
  }

  static Future<UserModel?> getUser() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var jsonUser = sharedPreference.getString("user");
    if (jsonUser != null) {
      return UserModel.fromJson(jsonUser);
    }
    return null;
  }
}
