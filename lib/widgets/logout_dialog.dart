// lib/widgets/logout_dialog.dart

import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final Function onLogoutConfirmed;

  const LogoutDialog({Key? key, required this.onLogoutConfirmed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without logging out
          },
        ),
        TextButton(
          child: const Text('Logout'),
          onPressed: () {
            onLogoutConfirmed(); // Call the logout function
            Navigator.of(context).pop(); // Close dialog
          },
        ),
      ],
    );
  }
}