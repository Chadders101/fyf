import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class PhraseScreen extends StatefulWidget {
  const PhraseScreen({Key? key}) : super(key: key);

  @override
  _PhraseScreenState createState() => _PhraseScreenState();
}

class _PhraseScreenState extends State<PhraseScreen> {
  List<Phrase> phrases = [];
  List<int> shownPhrases = [];
  int currentIndex = -1;
  final Random _random = Random();
  bool showExplanationOverlay = false;
  String currentExplanationText = '';
  String currentCardType = '';
  bool nsfwEnabled = true;
  bool endlessMode = true;

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
        phrases.shuffle(_random); // Shuffle the list of phrases
        _showExplanationCard(); // Show the explanation card first
      });
    } catch (e) {
      print('Error loading JSON: $e'); // Error log
    }
  }

  void _showExplanationCard() {
    setState(() {
      currentIndex = -1; // -1 indicates the explanation card
      currentCardType = 'Explanation';
    });
  }

  void _showPhrase(int index) {
    setState(() {
      currentIndex = index;
      if (!shownPhrases.contains(index)) {
        shownPhrases.add(index); // Add to shownPhrases if not already added
      }
      currentCardType = phrases[currentIndex].category;
    });
  }

  void _nextPhrase() {
    setState(() {
      currentIndex = (currentIndex + 1) % phrases.length;
      _showPhrase(currentIndex);
    });
  }

  void _previousPhrase() {
    setState(() {
      if (currentIndex > 0) {
        int previousIndex = shownPhrases.indexOf(currentIndex) - 1;
        if (previousIndex >= 0) {
          currentIndex = shownPhrases[previousIndex];
        } else {
          currentIndex = shownPhrases.first;
        }
        _showPhrase(currentIndex);
      }
    });
  }

  void _showExplanationOverlay(String text) {
    setState(() {
      currentExplanationText = text;
      showExplanationOverlay = true;
    });
  }

  void _hideExplanationOverlay() {
    setState(() {
      showExplanationOverlay = false;
    });
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to return to the main menu?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleNSFW(bool value) {
    setState(() {
      nsfwEnabled = value;
      if (!nsfwEnabled) {
        _filterNSFW();
      } else {
        _loadPhrases();
      }
    });
  }

  void _filterNSFW() {
    setState(() {
      phrases = phrases.where((phrase) => !phrase.nsfw).toList();
      shownPhrases.clear(); // Clear shownPhrases to reset the game
    });
  }

  void _toggleEndlessMode(bool value) {
    setState(() {
      endlessMode = value;
    });
  }

  void _startGame() {
    _nextPhrase();
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

    String displayedText;
    Color backgroundColor;

    if (currentIndex == -1) {
      displayedText = ''; // No text on the explanation card
      backgroundColor = Colors.white;
    } else {
      Phrase currentPhrase = phrases[currentIndex];
      displayedText = currentPhrase.text;
      switch (currentPhrase.category) {
        case 'Challenge':
          backgroundColor = Colors.yellow;
          currentExplanationText = 'Challenge: Explain the type here.';
          break;
        case 'Twist': // Updated from 'Loss' to 'Twist'
          backgroundColor = Colors.blue;
          currentExplanationText = 'Twist: Explain the type here.';
          break;
        case 'FyF':
          backgroundColor = Colors.green;
          currentExplanationText = 'FyF: Explain the type here.';
          break;
        default:
          backgroundColor = Colors.white;
          currentExplanationText = 'Default: Explain the type here.';
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: (details) {
              if (showExplanationOverlay) {
                _hideExplanationOverlay();
                return;
              }
              final screenWidth = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < screenWidth / 2) {
                _previousPhrase();
              } else {
                _nextPhrase();
              }
            },
            child: Container(
              color: backgroundColor,
              child: Center(
                child: currentIndex == -1
                    ? _buildExplanationCard()
                    : Text(
                  displayedText,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: _confirmExit,
            ),
          ),
          if (showExplanationOverlay)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _hideExplanationOverlay,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      currentExplanationText,
                      style: const TextStyle(fontSize: 18.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FyF: Explain the type here.', style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 10.0),
                    Text('Challenge: Explain the type here.', style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 10.0),
                    Text('Twist: Explain the type here.', style: TextStyle(fontSize: 18.0)), // Updated from 'Loss' to 'Twist'
                  ],
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Column(
              children: [
                _buildToggleSwitch('NSFW', nsfwEnabled, (value) => _toggleNSFW(value)),
                SizedBox(height: 20.0),
                _buildToggleSwitch('Endless', endlessMode, (value) => _toggleEndlessMode(value)),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.0),
        GestureDetector(
          onTap: _startGame,
          child: Text(
            'Start Game',
            style: TextStyle(fontSize: 24.0, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Text(
          label == 'NSFW' ? 'Safe' : 'Quick',
          style: TextStyle(
            color: value ? Colors.grey : Colors.black,
            fontSize: 16.0,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: TextStyle(
            color: value ? Colors.black : Colors.grey,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}

class Phrase {
  final String text;
  final String category;
  final bool nsfw;

  Phrase({required this.text, required this.category, required this.nsfw});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      text: json['text'],
      category: json['category'],
      nsfw: json['nsfw'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Phrase{text: $text, category: $category, nsfw: $nsfw}';
  }
}
