import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Settings'),
      ),
      body: Center(
        child: const Text('Settings Screen - Choose card packs'),
      ),
    );
  }
}
