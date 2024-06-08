import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'main_menu.dart';

class PhraseScreen extends StatefulWidget {
  const PhraseScreen({super.key});

  @override
  _PhraseScreenState createState() => _PhraseScreenState();
}

class _PhraseScreenState extends State<PhraseScreen> {
  List<Phrase> phrases = [];
  int currentIndex = 0;
  final Random _random = Random();
  List<int> shownIndices = [];

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    try {
      String data = await rootBundle.loadString('assets/phrases.json');
      List<dynamic> jsonResult = json.decode(data);
      setState(() {
        phrases = jsonResult.map((e) => Phrase.fromJson(e)).toList();
        phrases.shuffle(_random);
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  void _nextPhrase() {
    setState(() {
      if (shownIndices.length == phrases.length) {
        shownIndices.clear();
      }
      int nextIndex;
      do {
        nextIndex = _random.nextInt(phrases.length);
      } while (shownIndices.contains(nextIndex));
      currentIndex = nextIndex;
      shownIndices.add(currentIndex);
    });
  }

  void _showQuitConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit Game'),
          content: const Text('Are you sure you want to quit the game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                      (route) => false,
                );
              },
              child: const Text('Quit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (phrases.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Phrase currentPhrase = phrases[currentIndex];
    Color backgroundColor;

    switch (currentPhrase.category) {
      case 'Challenge':
        backgroundColor = Colors.yellow;
        break;
      case 'Loss':
        backgroundColor = Colors.blue;
        break;
      case 'FyF':
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.white;
    }

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _nextPhrase,
            child: Container(
              color: backgroundColor,
              child: Center(
                child: Text(
                  currentPhrase.text,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, size: 30),
              onPressed: _showQuitConfirmation,
            ),
          ),
        ],
      ),
    );
  }
}

class Phrase {
  final String text;
  final String category;

  Phrase({required this.text, required this.category});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      text: json['text'],
      category: json['category'],
    );
  }

  @override
  String toString() {
    return 'Phrase{text: $text, category: $category}';
  }
}
