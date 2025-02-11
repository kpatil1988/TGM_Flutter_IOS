import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'daily_nurtures_screen.dart';
import 'moodLog/log_mood_screen.dart';
import 'moodLog/instant_screen.dart'; // Import the InstantScreen

// Widget for displaying the Home screen content
class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}

// Main Home Screen containing bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeWidget(),
    InstantScreen(), // Now using non-const constructors
    LogMoodScreen(),
    DailyNurturesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isSignedIn = Provider.of<AuthProvider>(context).isSignedIn;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index, isSignedIn),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue, // Selected item text color
        unselectedItemColor: Colors.grey[300], // Unselected item text color
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold selected label
      ),
    );
  }

  void _onItemTapped(int index, bool isSignedIn) {
    if (index == 0 || isSignedIn) { // Allow access to home always
      setState(() {
        _selectedIndex = index;
      });
    } else {
      _showLoginPrompt(); // Show prompt if trying to access a restricted screen
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
                Navigator.of(ctx).pop();
                setState(() {
                  _selectedIndex = 0; // Reset to Home if not logged in
                });
              },
            ),
          ],
        );
      },
    );
  }
}