// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import '../screens/insights_screen.dart'; // Import the Insights screen
import '../screens/settings_screen.dart'; // Import the Settings screen
import '../screens/profile_screen.dart'; // Import the Profile screen

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFEFEFEF), // Light background color for iOS feel
        child: ListView(
          padding: EdgeInsets.zero, // No additional padding around the ListView
          children: [
            _buildDrawerHeader(context),
            // Updated drawer items with navigation
            _buildDrawerItem(context, Icons.person, 'Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()), // Navigate to ProfileScreen
              );
            }),
            _buildDrawerItem(context, Icons.dashboard, 'Insights', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InsightsScreen()),
              );
            }),
            _buildDrawerItem(context, Icons.settings, 'Settings', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 16.0, 16.0, 16.0), // Dynamic padding
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage('assets/images/profile.jpg'), // Your profile image
          ),
          const SizedBox(width: 16),
          const Text(
            'Welcome, User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap, // Add the tap function to navigate
      tileColor: Colors.transparent, // Transparent background
    );
  }
}