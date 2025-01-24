// lib/widgets/user_management_header.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Ensure this path is correct
import '../../screens/auth/login_dialog.dart'; // Import LoginDialog
import '../../screens/auth/sign_up_dialog.dart'; // Import SignUpDialog
import '../../screens/auth/logout_dialog.dart'; // Import LogoutDialog

class UserManagementHeader extends StatelessWidget implements PreferredSizeWidget {
  final Function(bool) onSignedIn;

  const UserManagementHeader({Key? key, required this.onSignedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isSignedIn = authProvider.isSignedIn;

    return AppBar(
      title: const Text('Golden Minds'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Login' && !isSignedIn) {
              showDialog(
                context: context,
                builder: (context) => const LoginDialog(), // Show the login dialog
              );
            } else if (value == 'Sign Up' && !isSignedIn) {
              showDialog(
                context: context,
                builder: (context) => const SignUpDialog(), // Show the signup dialog
              );
            } else if (value == 'Logout' && isSignedIn) {
              showDialog(
                context: context,
                builder: (context) => const LogoutDialog(), // Show the logout confirmation dialog
              ).then((_) {
                if (!authProvider.isSignedIn) {
                  // Notify parent about sign-out
                  onSignedIn(false);
                }
              });
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!isSignedIn)
              ...[
                const PopupMenuItem<String>(
                  value: 'Login',
                  child: Text('Login'),
                ),
                const PopupMenuItem<String>(
                  value: 'Sign Up',
                  child: Text('Sign Up'),
                ),
              ],
            if (isSignedIn)
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}