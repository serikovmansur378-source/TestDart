import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../main.dart';
import 'detail_screen.dart';

// Главный экран приложения, поддерживающий состояние
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Класс состояния главного экрана
class _HomeScreenState extends State<HomeScreen> {
  // Список для хранения категорий, полученных из базы данных
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // При старте экрана сразу загружаем данные из базы
  }

  // Асинхронный метод загрузки данных из БД и обновления стейта виджета
  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getCategories();
    setState(() {
      _categories = data; // Сохраняем полученные данные в переменную состояния
    });
  }

  // Метод, открывающий модальное окнонизу экрана для добавления новой категории
  void _showAddModal() {
    final titleController = TextEditingController(); // Контроллер для считывания текста заголовка
    final descController = TextEditingController(); // Контроллер для считывания описания
    IconData selectedIcon = Icons.star; // Дефолтная иконка для новой записи
    Color selectedColor = Colors.blue; // Дефолтный цвет для новой записи

    // Вызываем встроенную функцию Flutter для показа модального листа снизу
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Разрешаем модалке занимать больше места при появлении клавиатуры
      builder: (context) {
        return Padding(
          // Учитываем отступ снизу под системную клавиатуру телефона
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Сжимаем колонку по высоте содержимого
            crossAxisAlignment: CrossAxisAlignment.stretch, // Растягиваем элементы на всю ширину
            children: [
              const Text(
                'Создать новую категорию',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController, // Привязываем контроллер заголовка
                decoration: const InputDecoration(labelText: 'Название категории', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController, // Привязываем контроллер описания
                decoration: const InputDecoration(labelText: 'Описание', border: OutlineInputBorder()),
                maxLines: 3, // Делаем поле ввода многострочным
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return; // Если название пустое, ничего не делаем
                  // Сохраняем новую категорию через хелпер базы данных
                  await DatabaseHelper.instance.addCategory(
                    titleController.text,
                    descController.text,
                    selectedIcon,
                    selectedColor,
                  );
                  Navigator.pop(context); // Закрываем модальное окно после сохранения
                  _loadData(); // Перезагружаем список, чтобы увидеть новую запись
                },
                child: const Text('Сохранить в базу SQL'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справочник (Динамический SQL)'),
        actions: [
          // Кнопка на панели для вызова модального окна добавления записи
          IconButton(
            icon: const Icon(Icons.add_circle, size: 28),
            onPressed: _showAddModal,
            tooltip: 'Добавить категорию',
          ),
          // Кнопка быстрого переключения темы прямо из AppBar
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentTheme, _) {
              final isDark = currentTheme == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  // Меняем глобальное значение темы на противоположное
                  themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Используем GridView для вывода категорий в виде плиток (сетки)
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // Максимальная ширина одной плитки в сетке
            childAspectRatio: 1, // Квадратная форма плитки (пропорция 1:1)
            crossAxisSpacing: 16, // Отступ между плитками по горизонтали
            mainAxisSpacing: 16, // Отступ между плитками по вертикали
          ),
          itemCount: _categories.length, // Количество элементов берем из длины списка базы
          itemBuilder: (context, index) {
            final item = _categories[index]; // Достаем элемент по текущему индексу
            final color = Color(item['colorValue']); // Восстанавливаем цвет из целочисленного значения
            final icon = IconData(item['iconCode'], fontFamily: 'MaterialIcons'); // Восстанавливаем иконку

            return Card(
              elevation: 4, // Задаем тень для карточки
              child: InkWell(
                onTap: () {
                  // При нажатии на карточку переходим на экран подробной информации
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: item['title'],
                        description: item['description'],
                        icon: icon,
                        color: color,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Центрируем контент внутри карточки
                  children: [
                    Icon(icon, size: 48, color: color), // Отображаем иконку категории
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}