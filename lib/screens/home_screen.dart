// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'daily_nurtures_screen.dart'; // Ensure these files exist
import 'log_mood_screen.dart';       // Ensure these files exist
import 'instant_screen.dart';         // Ensure these files exist

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isSignedIn = false; // Placeholder for user's sign-in status

  // List of screens for each navigation item
  final List<Widget> _screens = [
    HomeWidget(),               // Default Home screen content
    InstantScreen(),            // Instant actions screen
    LogMoodScreen(),            // Screen for logging mood
    DailyNurturesScreen(),      // Screen for daily nurtures
  ];

  void _onItemTapped(int index) {
    if (index == 0 || isSignedIn) { // Allow access to Home screen always or if user is signed in
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    } else {
      _showLoginPrompt(); // Show login prompt if user is not signed in
    }
  }

  void _showLoginPrompt() {
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
                setState(() {
                  _selectedIndex = 0; // Redirect back to home screen
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: _screens[_selectedIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on, color: Colors.black),
            label: 'Instant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood, color: Colors.black),
            label: 'Log Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature, color: Colors.black),
            label: 'Daily Nurtures',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        onTap: _onItemTapped,          // Handle tab changes
        backgroundColor: Colors.black,  // Set the bottom navigation bar background color to black
        selectedItemColor: Colors.blue,  // Selected item color
        unselectedItemColor: Colors.white, // Unselected item color
      ),
    );
  }
}

// Widget used for Home screen content
class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to Home!',
        style: TextStyle(fontSize: 24, color: Colors.black), // Change text color to black for visibility
      ),
    );
  }
}