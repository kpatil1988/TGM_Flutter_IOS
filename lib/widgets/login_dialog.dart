// lib/widgets/login_dialog.dart

import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget {
  final Function(bool) setSignedIn;

  const LoginDialog({Key? key, required this.setSignedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        // Adjust this content according to your desired UI
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Add Text Fields for username/password and buttons
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
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Login'),
          onPressed: () {
            // Implement your login logic here
            setSignedIn(true); // Call setSignedIn with true if login is successful
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}