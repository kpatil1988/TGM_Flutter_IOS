import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure to import provider for accessing AuthProvider

import '../../providers/auth_provider.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Email/Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Validation logic
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    // Show an alert dialog if fields are empty
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please fill in both fields.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the alert
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // If fields are filled, call login function
                    Provider.of<AuthProvider>(context, listen: false).login();
                    Navigator.of(context).pop(); // Close the dialog on success
                  }
                },
                child: const Text('Login'),
              ),
              IconButton(
                icon: const Text("Fb"),
                onPressed: () {
                  // Handle Facebook login
                },
              ),
              IconButton(
                icon: const Text("G"),
                onPressed: () {
                  // Handle Google login
                },
              ),
              IconButton(
                icon: const Text("L"),
                onPressed: () {
                  // Handle LinkedIn login
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}