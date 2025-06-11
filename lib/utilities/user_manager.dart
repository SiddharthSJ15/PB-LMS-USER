import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const _tokenKey = "user_data";
  static Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tokenKey);
  }

  static Future<void> setUser(int user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tokenKey, user);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isTokenValid() async {
    final token = await getUser();
    return token != null;
  }
}
