import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/insights_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/health_sync_screen.dart'; // Import HealthSyncScreen
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1F1F1F), // Dark background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            _buildDrawerItem(context, Icons.person, 'Profile', () => _navigateToProfile(context)),
            _buildDrawerItem(context, Icons.dashboard, 'Insights', () => _navigateToInsights(context)),
            _buildDrawerItem(context, Icons.health_and_safety, 'Health Sync', () => _navigateToHealthSync(context)), // NEW MENU
            _buildDrawerItem(context, Icons.settings, 'Settings', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }),
            _buildThemeToggle(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 16.0, 16.0, 16.0),
      color: const Color(0xFF333333), // Header background color
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blue, // Avatar background color
          ),
          const SizedBox(width: 16),
          const Text(
            'Welcome, User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white, // Header text color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Icon color
      title: Text(title, style: const TextStyle(color: Colors.white)), // Text color
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: Colors.blueGrey, // Hover color
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SwitchListTile(
      title: const Text('Dark Mode', style: TextStyle(color: Colors.white)), // Text color
      value: authProvider.isDarkMode,
      onChanged: (bool value) {
        authProvider.toggleTheme();
      },
      secondary: const Icon(Icons.brightness_6, color: Colors.white), // Icon color
    );
  }

  void _navigateToProfile(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isSignedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      _showLoginPrompt(context);
    }
  }

  void _navigateToInsights(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isSignedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InsightsScreen()),
      );
    } else {
      _showLoginPrompt(context);
    }
  }

  void _navigateToHealthSync(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isSignedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HealthSyncScreen()), // NEW NAVIGATION
      );
    } else {
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
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}