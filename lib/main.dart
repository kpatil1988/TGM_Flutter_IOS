// lib/main.dart

import 'package:flutter/material.dart';
import 'widgets/user_management_header.dart';
import 'widgets/app_drawer.dart'; // Import the AppDrawer
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart'; // Import ProfileScreen if not already
import 'screens/insights_screen.dart'; // Import InsightsScreen
import 'screens/settings_screen.dart'; // Import SettingsScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isSignedIn = false; // Replace with your actual logic

    return MaterialApp(
      home: Scaffold(
        appBar: UserManagementHeader(isSignedIn: isSignedIn), // Keep this if desired
        drawer: const AppDrawer(), // Instancing the AppDrawer
        body: HomeScreen(), // Your main content area
      ),
    );
  }
}