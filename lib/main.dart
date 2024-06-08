import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'phrase_screen.dart';
import 'settings_screen.dart';
import 'info_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drinking Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
      routes: {
        '/game': (context) => const PhraseScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/info': (context) => const CardInfoScreen(),
      },
    );
  }
}
