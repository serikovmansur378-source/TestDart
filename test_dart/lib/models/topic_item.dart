import 'package:flutter/material.dart';

// Класс-модель для описания структуры объекта темы/категории в коде (в памяти)
class TopicItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TopicItem({
    required this.title,
    required this.description,
    required this.icon,
    this.color = Colors.blue, // Цвет по умолчанию синий, если не передан
  });
}