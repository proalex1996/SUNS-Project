import 'package:shared_preferences/shared_preferences.dart';

import '../app-const.dart';

class AppAuthService {
  Future<bool> get isAuthentication async {
    var token = await this.getToken();

    return token != null && token != "";
  }

  Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString(AppConst.AuthTokenName);
  }

  Future<bool> setToken(String token) async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.setString(AppConst.AuthTokenName, token);
  }

  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    
    return prefs.remove(AppConst.AuthTokenName);
  }
}
