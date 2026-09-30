import 'dart:convert';
import 'package:flutter/services.dart';

class LanguageService {
  static Map<String, String> _localizedStrings = {};

  static Future<void> load(String langCode) async {
    try {
      String jsonString = await rootBundle.loadString('assets/lang/$langCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      // Фолбэк, если файл не найден
      _localizedStrings = {};
    }
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}