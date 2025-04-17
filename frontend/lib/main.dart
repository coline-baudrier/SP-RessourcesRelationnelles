import 'package:flutter/material.dart';
import 'package:frontend/scenes/tableau_de_bord_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableauDeBordPage()
    );
  }
}