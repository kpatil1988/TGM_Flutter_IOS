import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider for AuthProvider
import '../screens/insights_screen.dart'; // Import the Insights screen
import '../screens/settings_screen.dart'; // Import the Settings screen
import '../screens/profile_screen.dart'; // Import the Profile screen
import '../providers/auth_provider.dart'; // Import AuthProvider

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
            _buildDrawerItem(context, Icons.person, 'Profile', () => _navigateToProfile(context)),
            _buildDrawerItem(context, Icons.dashboard, 'Insights', () => _navigateToInsights(context)),
            _buildDrawerItem(context, Icons.settings, 'Settings', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildThemeToggle(context), // Add the theme toggle here
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

  Widget _buildThemeToggle(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Get the AuthProvider
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: authProvider.isDarkMode,
      onChanged: (bool value) {
        authProvider.toggleTheme(); // Call toggle function from AuthProvider
      },
      secondary: const Icon(Icons.brightness_6), // Optional icon
    );
  }

  void _navigateToProfile(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get the AuthProvider
    if (authProvider.isSignedIn) {
      // User is signed in, navigate to ProfileScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      // User is not signed in, show login prompt
      _showLoginPrompt(context);
    }
  }

  void _navigateToInsights(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get the AuthProvider
    if (authProvider.isSignedIn) {
      // User is signed in, navigate to InsightsScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InsightsScreen()),
      );
    } else {
      // User is not signed in, show login prompt
      _showLoginPrompt(context);
    }
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Log In Required'),
          content: const Text('Please log in to access this feature.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}