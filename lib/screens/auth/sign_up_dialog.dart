// lib/widgets/sign_up_dialog.dart
import 'package:flutter/material.dart';

class SignUpDialog extends StatelessWidget {
  const SignUpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Sign Up'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle sign-up logic here
              Navigator.of(context).pop(); // Close the dialog on success
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}