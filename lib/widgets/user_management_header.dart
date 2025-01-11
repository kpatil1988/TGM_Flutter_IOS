// lib/widgets/user_management_header.dart

import 'package:flutter/material.dart';
import 'login_dialog.dart';
import 'sign_up_dialog.dart';
import 'logout_dialog.dart'; // Import the logout dialog

class UserManagementHeader extends StatefulWidget implements PreferredSizeWidget {
  const UserManagementHeader({Key? key}) : super(key: key);

  @override
  _UserManagementHeaderState createState() => _UserManagementHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Set the preferred size for the AppBar
}

class _UserManagementHeaderState extends State<UserManagementHeader> {
  bool isSignedIn = false; // Local state to track sign-in status

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Golden Minds'),
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'Login') {
              _showLoginDialog(context);
            } else if (value == 'Sign Up') {
              _showSignUpDialog(context);
            } else if (value == 'Logout') {
              _showLogoutDialog(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              if (!isSignedIn)
                const PopupMenuItem<String>(
                  value: 'Login',
                  child: Text('Login'),
                ),
              if (!isSignedIn)
                const PopupMenuItem<String>(
                  value: 'Sign Up',
                  child: Text('Sign Up'),
                ),
              if (isSignedIn)
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
            ];
          },
        ),
      ],
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LoginDialog(setSignedIn: (bool value) {
        setState(() {
          isSignedIn = value;
        });
      }),
    );
  }

  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SignUpDialog(setSignedIn: (bool value) {
        setState(() {
          isSignedIn = value;
        });
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LogoutDialog(onLogoutConfirmed: () {
        _logout(); // Call the logout logic
      }),
    );
  }

  void _logout() {
    setState(() {
      isSignedIn = false; // Reset the sign-in status
    });
    print('User logged out');
  }
}