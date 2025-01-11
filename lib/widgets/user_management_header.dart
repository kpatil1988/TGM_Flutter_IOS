// lib/widgets/user_management_header.dart

import 'package:flutter/material.dart';

class UserManagementHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isSignedIn;

  const UserManagementHeader({Key? key, required this.isSignedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Golden Minds'), // Set the AppBar title
      actions: <Widget>[
        // Show sign-in and sign-up options if user is not signed in
        if (!isSignedIn)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // Icon for the popup menu
            onSelected: (value) {
              if (value == 'Sign In') {
                _showSignInOptions(context);
              } else if (value == 'Sign Up') {
                _showSignUpForm(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Sign In', 'Sign Up'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
      ],
    );
  }

  void _showSignInOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Sign In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sign In with Mobile'),
                onTap: () {
                  // Handle Mobile sign in
                  Navigator.of(ctx).pop(); // Close dialog
                },
              ),
              ListTile(
                title: const Text('Sign In with Username/Password'),
                onTap: () {
                  // Handle Username/Password sign in
                  Navigator.of(ctx).pop(); // Close dialog
                },
              ),
              ListTile(
                title: const Text('Sign In with Google'),
                onTap: () {
                  // Handle Google sign in
                  Navigator.of(ctx).pop(); // Close dialog
                },
              ),
              ListTile(
                title: const Text('Sign In with Instagram'),
                onTap: () {
                  // Handle Instagram sign in
                  Navigator.of(ctx).pop(); // Close dialog
                },
              ),
              ListTile(
                title: const Text('Sign In with LinkedIn'),
                onTap: () {
                  // Handle LinkedIn sign in
                  Navigator.of(ctx).pop(); // Close dialog
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignUpForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Sign Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Handle sign-up logic
                Navigator.of(ctx).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Preferred height for AppBar
}