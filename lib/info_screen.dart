import 'package:flutter/material.dart';

class CardInfoScreen extends StatelessWidget {
  const CardInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Card Info Screen - Display each type of card with details'),
          ],
        ),
      ),
    );
  }
}
