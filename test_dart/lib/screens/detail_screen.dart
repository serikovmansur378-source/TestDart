import 'package:flutter/material.dart';
import '../models/topic_item.dart';
import '../services/language_service.dart';
import '../main.dart';

class DetailScreen extends StatelessWidget {
  final TopicItem item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LanguageService.translate(item.title)),
            backgroundColor: item.color,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, size: 80, color: item.color),
                const SizedBox(height: 20),
                Text(
                  LanguageService.translate(item.title),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  LanguageService.translate(item.description),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}