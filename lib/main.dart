// lib/main.dart

import 'package:flutter/material.dart';
import 'widgets/user_management_header.dart';
import 'widgets/app_drawer.dart'; // Import the AppDrawer
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart'; // Import ProfileScreen if not already
import 'screens/insights_screen.dart'; // Import InsightsScreen
import 'screens/settings_screen.dart'; // Import SettingsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Add key for better widget performance

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(), // Use MainScreen as the home widget
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key); // Create a new MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserManagementHeader(), // Init without isSignedIn
      drawer: const AppDrawer(), // Instancing the AppDrawer
      body: const HomeScreen(), // Your main content area
    );
  }
}