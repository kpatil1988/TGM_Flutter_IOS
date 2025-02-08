// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'widgets/user_management_header.dart';
import 'widgets/app_drawer.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_dialog.dart';
import 'config/config.dart';
import 'screens/inAppActivities/affirmation_catcher.dart';
import 'screens/inAppActivities/bouncing_balls.dart';
import 'screens/inAppActivities/breath_activity.dart';
import 'screens/inAppActivities/flip_the_story.dart';
import 'screens/inAppActivities/zenscribbler.dart';
import 'screens/inAppActivities/bubble_wrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.load(); // Load configuration settings

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadCookies()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoldenMinds',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
      routes: {
        '/affirmationCatcher': (context) => const AffirmationCatcher(),
        '/breath': (context) => const Breathe(),
        '/bubbleWrap': (context) => const VirtualBubbleWrap(),
        '/flipTheStory': (context) => const FlipTheStory(),
        '/bouncingBalls': (context) => const BouncingBalls(),
        '/zenScribbler': (context) => const ZenScribbler()
        // Add more routes here if needed
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserManagementHeader(
        onSignedIn: (bool isSignedIn) {
          if (!isSignedIn) {
            _showLoginDialog(context);
          }
        },
      ),
      drawer: const AppDrawer(),
      body: const HomeScreen(),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoginDialog();
      },
    );
  }
}