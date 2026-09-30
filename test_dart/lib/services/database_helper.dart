// Импортируем основной пакет SQLite для Flutter
import 'package:sqflite/sqflite.dart';
// Импортируем библиотеку path для безопасного склеивания путей к файлам
import 'package:path/path.dart';
// Импортируем Material для доступа к цветам и иконкам в дефолтных данных
import 'package:flutter/material.dart';

// Класс-помощник для работы с локальной базой данных (Singleton-паттерн)
class DatabaseHelper {
  // Создаем единственный экземпляр класса для всего приложения (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();
  // Приватная переменная для хранения ссылки на открытую базу данных
  static Database? _database;

  // Приватный конструктор, запрещающий создание объектов извне
  DatabaseHelper._init();

  // Геттер для получения экземпляра базы данных (ленивая инициализация)
  Future<Database> get database async {
    if (_database != null) return _database!; // Если база уже открыта, возвращаем её
    _database = await _initDB('categories.db'); // Иначе создаем/открываем файл 'categories.db'
    return _database!;
  }

  // Метод инициализации файла базы данных на устройстве
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Получаем стандартный путь к базам данных ОС
    final path = join(dbPath, filePath); // Объединяем путь и имя файла базы данных

    // Открываем базу данных, задавая версию и метод создания при первом запуске
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Метод, вызываемый единожды при самом первом создании файла базы данных
  Future _createDB(Database db, int version) async {
    // Выполняем SQL-запрос на создание таблицы 'categories' со всеми необходимыми полями
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        iconCode INTEGER NOT NULL,
        colorValue INTEGER NOT NULL
      )
    ''');

    // Вставляем дефолтную запись №1: Космос
    await db.insert('categories', {
      'title': 'Космос',
      'description': 'В данном разделе будет информация про метеориты, планеты, галактику и звёзды.',
      'iconCode': Icons.rocket_launch.codePoint, // Сохраняем числовой код иконки
      'colorValue': Colors.deepPurple.value, // Сохраняем числовое значение цвета
    });
    // Вставляем дефолтную запись №2: Программирование
    await db.insert('categories', {
      'title': 'Программирование',
      'description': 'Бұл бөлімде Python, C++ және Dart қарастырылады.',
      'iconCode': Icons.code.codePoint,
      'colorValue': Colors.green.value,
    });
  }

  // Метод для получения всех категорий из базы данных в виде списка словарей (Map)
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await instance.database; // Получаем доступ к базе
    return await db.query('categories'); // Делаем SELECT * FROM categories
  }

  // Метод для добавления новой категории в базу данных с передачей параметров
  Future<int> addCategory(String title, String description, IconData icon, Color color) async {
    final db = await instance.database;
    return await db.insert('categories', { // Вставляем новую запись в таблицу
      'title': title,
      'description': description,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
    });
  }
}