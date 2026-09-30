// Импортируем библиотеку для работы с операционной системой (проверка платформы: Windows/Linux/Mac)
import 'dart:io';
// Основной пакет Flutter для создания интерфейсов и виджетов
import 'package:flutter/material.dart';
// Пакет для инициализации SQLite на десктопных ОС через FFI
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// Сервис для подгрузки локализации (переводов)
import 'services/language_service.dart';
// Главный экран приложения
import 'screens/home_screen.dart';

// Глобальный переключатель темы приложения (светлая/темная), начальное значение — светлая
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
// Глобальный переключатель языка, по умолчанию 'ru'
final ValueNotifier<String> languageNotifier = ValueNotifier('ru');

// Главная асинхронная функция, с которой стартует приложение
void main() async {
  // Гарантируем, что движок Flutter полностью инициализирован до вызова нативных асинхронных методов
  WidgetsFlutterBinding.ensureInitialized();

  // Проверяем ОС: если это десктоп, настраиваем SQLite через FFI, так как стандартного нативного драйвера там нет
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Инициализация FFI-драйвера SQLite
    databaseFactory = databaseFactoryFfi; // Меняем фабрику базы данных на десктопную версию
  }

  // Асинхронно загружаем русский язык интерфейса при старте
  await LanguageService.load('ru');

  // Запускаем корневой виджет приложения
  runApp(const MyApp());
}

// Корневой stateless-виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Слушаем изменения глобальной темы через ValueListenableBuilder
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        // Внутри слушаем еще и изменения языка для реактивного перерисоввывания
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, _) {
            // Возвращаем стандартный каркас MaterialApp с настройками тем и роутинга
            return MaterialApp(
              title: 'School App', // Название приложения в системе
              debugShowCheckedModeBanner: false, // Убираем плашку "Debug" в правом верхнем углу
              theme: ThemeData(
                useMaterial3: true, // Включаем современный дизайн Material 3
                colorSchemeSeed: Colors.blue, // Задаем базовый синий цвет для генерации палитры
                brightness: Brightness.light, // Указываем светлую яркость темы
              ),
              darkTheme: ThemeData(
                useMaterial3: true, // Включаем Material 3 и для темной темы
                colorSchemeSeed: Colors.blue, // Базовый цвет палитры
                brightness: Brightness.dark, // Указываем темную яркость темы
              ),
              themeMode: currentTheme, // Передаем текущую тему из нашего Notifier
              home: const HomeScreen(), // Указываем стартовый экран приложения
            );
          },
        );
      },
    );
  }
}