import 'package:flutter/material.dart';
import 'scenes/connexion.dart'; // Assurez-vous d'importer votre page de connexion
import 'package:frontend/scenes/catalogue.dart';
import 'package:frontend/scenes/IncriptionPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Catalogue());
  }
}
