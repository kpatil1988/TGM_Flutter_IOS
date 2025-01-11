// lib/widgets/logout_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle logout logic here
            // If fields are filled, call login function
             Provider.of<AuthProvider>(context, listen: false).logout();
             Navigator.of(context).pop(); // Close the dialog on success
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}