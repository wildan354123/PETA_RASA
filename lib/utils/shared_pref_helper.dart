import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Simpan username dan password secara terpisah
  static Future<void> saveUserData(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  // Ambil username dan password
  static Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_keyUsername);
    final password = prefs.getString(_keyPassword);

    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  // Simpan status login
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  // Ambil status login
  static Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}
