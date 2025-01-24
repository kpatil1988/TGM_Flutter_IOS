import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class ApiService {
  String? _cookies;

  // Load cookies from shared preferences
  Future<void> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cookies = prefs.getString('cookies');
  }

  // Set the authentication cookie
  Future<void> setAuthCookie(String cookie) async {
    _cookies = cookie;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookies', cookie);
  }

  // Clear the authentication cookie
  Future<void> clearCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cookies');
    _cookies = null;
  }

  // Method for making GET requests
  Future<dynamic> get(String endpoint) async {
    await loadCookies(); // Ensure cookies are loaded before making the request
    String baseUrl = Config.baseUrl;

    print("Cookies before GET request: $_cookies"); // Debug print to verify cookies
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (_cookies != null) 'Cookie': _cookies!,
        },
      );

      // Handle the response appropriately
      return _handleResponse(response);
    } catch (e) {
      print('Error during GET request: $e');
      throw Exception('Error during GET request: $e');
    }
  }

  // Method for making POST requests
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await loadCookies(); // Ensure cookies are loaded before making the request
    String baseUrl = Config.baseUrl;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (_cookies != null) 'Cookie': _cookies!,
        },
        body: jsonEncode(data),
      );

      // Handle the response appropriately
      return _handleResponse(response);
    } catch (e) {
      print('Error during POST request: $e');
      throw Exception('Error during POST request: $e');
    }
  }

  // Method for making PUT requests
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    await loadCookies(); // Ensure cookies are loaded before making the request
    String baseUrl = Config.baseUrl;

    print("Cookies before PUT request: $_cookies"); // Debug print to verify cookies
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (_cookies != null) 'Cookie': _cookies!,
        },
        body: jsonEncode(data),
      );

      // Handle the response appropriately
      return _handleResponse(response);
    } catch (e) {
      print('Error during PUT request: $e');
      throw Exception('Error during PUT request: $e');
    }
  }

  // Handle responses and return data or throw exceptions
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        return responseData is List
            ? responseData
            : responseData is Map
                ? responseData
                : throw Exception('Unexpected response type: ${responseData.runtimeType}');

      case 401:
        throw Exception('Unauthorized access. Please check your credentials.');

      case 404:
        throw Exception('Resource not found: ${response.body}');

      default:
        throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }
}