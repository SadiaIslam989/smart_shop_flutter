import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _loginKey = 'isLoggedIn';
  static const String _emailKey = 'savedEmail';
  static const String _passwordKey = 'savedPassword';

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

 
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); 

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_emailKey);
    final savedPassword = prefs.getString(_passwordKey);

    if (savedEmail == null || savedPassword == null) {
      throw Exception("No registered user found. Please register first.");
    }

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool(_loginKey, true);
      _isLoggedIn = true;
      notifyListeners();
    } else {
      throw Exception("Invalid email or password");
    }
  }
  //new user
  Future<void> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); 

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);

    await prefs.setBool(_loginKey, true);
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Logout 
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
    _isLoggedIn = false;
    notifyListeners();
  }

 
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    notifyListeners();
  }
}
