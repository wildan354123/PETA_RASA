import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Memuat status login dari SharedPreferences
  Future<void> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isSignedIn') ?? false;
    notifyListeners();  // Memberitahu widget lain bahwa status login telah diperbarui
  }

  // Mengatur status login dari SharedPreferences
  void setLoginStatus(bool status) {
    _isLoggedIn = status;
    notifyListeners();
  }

  // Menangani proses login
  Future<void> logIn(String username, String password) async {
    _isLoggedIn = true; // Status login diubah

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', true);  // Menyimpan status login ke SharedPreferences
    await prefs.setString('username', username);
    notifyListeners();  // Memberitahu widget untuk merender ulang
  }

  // Menangani proses logout
  Future<void> logOut() async {
    _isLoggedIn = false; // Status login diubah

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', false);  // Menghapus status login dari SharedPreferences
    await prefs.remove('username');
    notifyListeners();  // Memberitahu widget untuk merender ulang
  }
}
