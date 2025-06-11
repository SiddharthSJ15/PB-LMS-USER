import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _tokenKey = "user_token";
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  } 
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
  Future<bool> isTokenValid() async {
    final token = await getToken();
    // Here you can add additional logic to validate the token, such as checking its expiration
    
    // For simplicity, we just check if the token is not null and not empty.
    return token != null && token.isNotEmpty;
  }
}