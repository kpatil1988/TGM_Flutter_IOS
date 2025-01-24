import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? loginError; // Holds the error message

  Future<void> _handleLogin(BuildContext context) async {
    // Grab username and password
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Check for empty fields
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        loginError = 'Please enter both email/username and password';
      });
      return;
    }

    // Call the login method in AuthProvider
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(username, password);

      // Check if login is successful
      if (authProvider.user != null) {
        // Close dialog and show Snackbar on success
        Navigator.of(context).pop(); // Close the login popup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged in successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // If login fails but no specific error is thrown
        setState(() {
          loginError = 'Invalid username or password'; // Display error on screen
        });
      }
    } catch (error) {
      // If any error occurs during the login process
      setState(() {
        loginError = error.toString(); // Show error on the screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username field
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Email/Username'),
          ),

          // Password field
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),

          // Error message (display when loginError is non-null)
          if (loginError != null) ...[
            const SizedBox(height: 10),
            Text(
              loginError!,
              style: const TextStyle(color: Colors.red),
            ),
          ],

          const SizedBox(height: 20),

          // Login button
          ElevatedButton(
            onPressed: () => _handleLogin(context),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}