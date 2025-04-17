import 'package:flutter/material.dart';
import 'package:frontend/scenes/MenuModerPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuModerPage(),
    );
  }
}
