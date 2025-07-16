import 'package:flutter/material.dart';

void main() {
  runApp(const AeroSenseApp());
}

class AeroSenseApp extends StatelessWidget {
  const AeroSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroSense',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AeroSense'),
      ),
      body: const Center(
        child: Text(
          'Welcome to AeroSense!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
