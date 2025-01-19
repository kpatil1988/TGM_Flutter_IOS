// lib/config/config.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  static String _baseUrl = '';

  static Future<void> load() async {
    final configString = await rootBundle.loadString('assets/config.json');
    final configData = jsonDecode(configString);
    _baseUrl = configData['baseUrl'];
  }

  static String get baseUrl => _baseUrl;
}