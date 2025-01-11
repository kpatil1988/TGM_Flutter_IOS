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

  // List of screens for each navigation item
  final List<Widget> _screens = [
    HomeWidget(),               // Default Home screen content
    InstantScreen(),            // Instant actions screen
    LogMoodScreen(),            // Screen for logging mood
    DailyNurturesScreen(),      // Screen for daily nurtures
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;   // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: _screens[_selectedIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black), // Change icon color for visibility
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on, color: Colors.black), // Change icon color for visibility
            label: 'Instant',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.mood, color: Colors.black), // Change icon color for visibility
            label: 'Log Mood',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.nature, color: Colors.black), // Change icon color for visibility
            label: 'Daily Nurtures',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        onTap: _onItemTapped,          // Handle tab changes
        backgroundColor: Colors.black,  // Set the bottom navigation bar background color to white
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