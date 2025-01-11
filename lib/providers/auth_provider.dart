import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isSignedIn = false;
  bool _isDarkMode = false; // Add a new field for dark mode

  bool get isSignedIn => _isSignedIn;
  bool get isDarkMode => _isDarkMode; // Getter for dark mode

  void login() {
    _isSignedIn = true;
    notifyListeners(); // Notify listeners to rebuild affected widgets
  }

  void logout() {
    _isSignedIn = false;
    notifyListeners(); // Notify listeners to rebuild affected widgets
  }
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Toggle the dark mode state
    notifyListeners(); // Notify listeners to rebuild related widgets
  }
}