import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CardInfoScreen extends StatefulWidget {
  const CardInfoScreen({Key? key}) : super(key: key);

  @override
  _CardInfoScreenState createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  List<Phrase> phrases = [];

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
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Information'),
      ),
      body: phrases.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoText(
                'Below is an explanation of the three card types.'),
            _buildCardTypeInfo(
              'Challenge',
              'Placeholder text for Challenge cards.',
              Colors.yellow,
            ),
            _buildCardTypeInfo(
              'Loss',
              'Placeholder text for Loss cards.',
              Colors.blue,
            ),
            _buildCardTypeInfo(
              'FyF',
              'Placeholder text for FyF cards.',
              Colors.green,
            ),
            _buildInfoText('Card examples:'),
            ...phrases.map((phrase) => _buildCardInfo(phrase)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeInfo(String title, String description, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }


  Widget _buildCardInfo(Phrase phrase) {
    Color backgroundColor;
    switch (phrase.category) {
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

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Text(
        phrase.text,
        style: const TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
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
}
