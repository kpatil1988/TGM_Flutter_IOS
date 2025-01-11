// lib/widgets/sign_up_dialog.dart

import 'package:flutter/material.dart';

class SignUpDialog extends StatelessWidget {
  final Function(bool) setSignedIn;

  const SignUpDialog({Key? key, required this.setSignedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Up'),
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
          child: const Text('Sign Up'),
          onPressed: () {
            // Implement your signup logic here
            //setSignedIn(true); // Call setSignedIn with true if signup is successful
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}