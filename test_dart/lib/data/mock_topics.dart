import 'package:flutter/material.dart';
import '../models/topic_item.dart';

final List<TopicItem> topicsData = [
  const TopicItem(
    title: 'space_title',
    description: 'space_desc',
    icon: Icons.rocket_launch,
    color: Colors.deepPurple,
  ),
  const TopicItem(
    title: 'code_title',
    description: 'code_desc',
    icon: Icons.code,
    color: Colors.green,
  ),
  const TopicItem(
    title: 'history_title',
    description: 'history_desc',
    icon: Icons.menu_book,
    color: Colors.amber,
  ),
];

