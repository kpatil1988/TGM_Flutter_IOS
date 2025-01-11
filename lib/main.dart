import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/user_management_header.dart';
import 'widgets/app_drawer.dart'; // Import the AppDrawer
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart'; // Import ProfileScreen if not already
import 'screens/insights_screen.dart'; // Import InsightsScreen
import 'screens/settings_screen.dart'; // Import SettingsScreen
import 'providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(), // Initialize the AuthProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Add key for better widget performance

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access AuthProvider
    return MaterialApp(
      title: 'My App',
      theme: authProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(), // Toggling themes
      home: const MainScreen(), // Use MainScreen as the home widget
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key); // Create a new MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserManagementHeader(
        onSignedIn: (bool isSignedIn) {
          // Handle updated sign-in state
          // You can add logic here to update the UI or app state as needed
          print('Sign-in state changed: $isSignedIn');
        },
      ), // Now initialized with onSignedIn parameter
      drawer: const AppDrawer(), // Instancing the AppDrawer
      body: const HomeScreen(), // Your main content area
    );
  }
}