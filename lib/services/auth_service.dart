import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String? _cookies;

  // Load cookies from shared preferences
  Future<void> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cookies = prefs.getString('cookies');
  }

// Login method to authenticate the user
Future<User?> login(String usernameOrEmail, String password) async {
    final String url = '${Config.baseUrl}/api/users/login';

    try {
        final response = await http.post(
            Uri.parse(url),
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'username': usernameOrEmail, 'password': password}),
        );

        if (response.statusCode == 200) {
            // Extract and store the cookies
            _cookies = response.headers['set-cookie'];
            print("_cookies after login: $_cookies"); // Debug print to verify cookies

            // Store the cookies in shared preferences for future requests
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (_cookies != null) {
                await prefs.setString('cookies', _cookies!);
            }
            return User.fromJson(jsonDecode(response.body));
        } else {
            print('Failed to login: ${response.statusCode} - ${response.body}');
            throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
        }
    } catch (e) {
        print('Error during login: $e');
        return null;
    }
}

  // Clear cookies from shared preferences
  Future<void> clearCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cookies');  // Remove the cookies from shared preferences
  }

  // Print cookies for debugging purposes
  Future<void> printCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('cookies');
    
    if (cookies != null && cookies.isNotEmpty) {
      print('Cookies are set: $cookies');
    } else {
      print('No cookies found.');
    }
  }

  // Get the current user from the API
  Future<User?> getCurrentUser() async {
    final String url = '${Config.baseUrl}/api/users/current';

    await loadCookies(); // Ensure cookies are loaded before making the request
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (_cookies != null) 'Cookie': _cookies!,
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to fetch current user: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }

    return null; // Return null if unable to validate session
  }
}