import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../data/mock_topics.dart';
import '../main.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LanguageService.translate('directory')),
            actions: [
              TextButton(
                onPressed: () async {
                  final nextLang = currentLang == 'ru' ? 'kz' : 'ru';
                  await LanguageService.load(nextLang);
                  languageNotifier.value = nextLang;
                },
                child: Text(
                  currentLang == 'ru' ? 'KZ' : 'RU',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentTheme, _) {
                  final isDark = currentTheme == ThemeMode.dark;
                  return IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: topicsData.length,
              itemBuilder: (context, index) {
                final item = topicsData[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(item: item),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 48, color: item.color),
                        const SizedBox(height: 12),
                        Text(
                          LanguageService.translate(item.title),
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
      },
    );
  }
}