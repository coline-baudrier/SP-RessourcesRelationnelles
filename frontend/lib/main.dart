import 'package:flutter/material.dart';
import 'package:frontend/scenes/creation-ressource.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants Relationnelles', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Couleur principale
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreationRessourcePage(), // Remplacez par votre page de connexion
    );
  }
}
