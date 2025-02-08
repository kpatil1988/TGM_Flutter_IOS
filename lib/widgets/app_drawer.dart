import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/insights_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/health_sync_screen.dart';
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
            _buildDrawerItem(context, Icons.health_and_safety, 'Health Sync', () => _navigateToHealthSync(context)),
            _buildRestrictedActivitiesMenu(context), // Restricted Activities Menu
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
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: Colors.blueGrey.shade700,
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SwitchListTile(
      title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
      value: authProvider.isDarkMode,
      onChanged: (bool value) {
        authProvider.toggleTheme();
      },
      secondary: const Icon(Icons.brightness_6, color: Colors.white),
    );
  }

  Widget _buildRestrictedActivitiesMenu(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is signed in
    if (!authProvider.isSignedIn) {
      return ListTile(
        leading: const Icon(Icons.directions_run, color: Colors.blueAccent),
        title: const Text(
          'Activities',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          _showLoginPrompt(context); // Show login prompt if user is not signed in
        },
      );
    }

    // If the user is signed in, show the Activities menu
    return ExpansionTile(
      leading: const Icon(Icons.directions_run, color: Colors.blueAccent),
      title: const Text(
        'Activities',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      children: [
        _buildSubMenuItem(context, 'Inhale/Exhale', () {
          Navigator.pushNamed(context, '/breath');
        }),
        _buildSubMenuItem(context, 'Affirmation Catcher', () {
          Navigator.pushNamed(context, '/affirmationCatcher');
        }),
        _buildSubMenuItem(context, 'Bubble Wrap', () {
          Navigator.pushNamed(context, '/bubbleWrap');
        }),
        _buildSubMenuItem(context, 'Flip the Story', () {
          Navigator.pushNamed(context, '/flipTheStory');
        }),
        _buildSubMenuItem(context, 'Bouncing Balls', () {
          Navigator.pushNamed(context, '/bouncingBalls');
        }),
        _buildSubMenuItem(context, 'Zen Scribbler', () {
          Navigator.pushNamed(context, '/zenScribbler');
        }),
      ],
    );
  }

  Widget _buildSubMenuItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
      hoverColor: Colors.blueGrey.shade700,
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
        MaterialPageRoute(builder: (context) => const HealthSyncScreen()),
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