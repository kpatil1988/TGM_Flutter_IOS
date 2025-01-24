import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isDarkMode = false;

  User? get user => _user;
  bool get isDarkMode => _isDarkMode;
  bool get isSignedIn => _user != null;

  // Load cookies and attempt to auto-login if a valid session exists
  Future<void> loadCookies() async {
    try {
      // Load cookies stored in shared preferences
      await _authService.loadCookies();
      await _authService.printCookies();

      // Attempt to auto-login if cookies are valid
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _user = user;
        notifyListeners(); // Notify listeners about the state change
        print("User auto-logged in with cookies.");
      } else {
        print("No valid session found.");
      }
    } catch (error) {
      print("Error loading cookies or validating session: $error");
    }
  }

  // Login method
  Future<void> login(String usernameOrEmail, String password) async {
    try {
      final user = await _authService.login(usernameOrEmail, password);
      if (user != null) {
        _user = user;
        notifyListeners(); // Notify listeners when login is successful
        print("User logged in successfully.");
      } else {
        print("Failed to login: User is null");
        throw Exception('Invalid username or password'); // Throw to be handled by UI
      }
    } catch (error) {
      print('Error logging in: $error');
      rethrow; // Rethrow error to be handled by UI
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    await _authService.clearCookies(); // Clear cookies upon logout
    notifyListeners();
    print("User has logged out and cookies have been cleared.");
  }

  // Toggle the theme between light and dark mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}