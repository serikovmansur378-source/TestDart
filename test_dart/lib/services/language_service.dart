// Импортируем кодировщик для парсинга JSON
import 'dart:convert';
// Импортируем системные утилиты для доступа к файлам ресурсов (assets)
import 'package:flutter/services.dart';

// Класс-сервис для управления языками и переводами
class LanguageService {
  // Приватная карта, хранящая пары ключ-значение для переведенных строк
  static Map<String, String> _localizedStrings = {};

  // Метод для асинхронной загрузки JSON-файла с переводами по коду языка (например, 'ru' или 'kk')
  static Future<void> load(String langCode) async {
    try {
      // Загружаем текстовое содержимое JSON-файла из папки assets
      String jsonString = await rootBundle.loadString('assets/lang/$langCode.json');
      // Декодируем строку в стандартный Dart Map
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Преобразуем динамическую карту в строковую карту для безопасности типов
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      // Если файл не найден или произошла ошибка, сбрасываем переводы в пустую карту
      _localizedStrings = {};
    }
  }

  // Метод получения перевода по ключу; если ключ не найден, возвращает сам ключ в качестве фоллбека
  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}