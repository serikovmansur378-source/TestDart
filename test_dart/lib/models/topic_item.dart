// ignore: unused_import
import 'package:flutter/material.dart';

class TopicItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TopicItem({
    required this.title,
    required this.description,
    required this.icon,
    this.color = Colors.blue,
  });
}