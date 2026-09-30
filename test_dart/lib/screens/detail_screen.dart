import 'package:flutter/material.dart';

// Экран подробной информации о выбранной категории
class DetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const DetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Заголовок AppBar равен названию категории
        backgroundColor: color, // Красим шапку в цвет категории
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Выравниваем содержимое по левому краю
          children: [
            Icon(icon, size: 80, color: color), // Крупная иконка категории вверху
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description, // Полное описание категории из базы данных
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}