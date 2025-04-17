import 'package:flutter/material.dart';
import 'scenes/connexion.dart'; // Assurez-vous d'importer votre page de connexion

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
      home: const LoginPage(), // Remplacez par votre page de connexion
    );
  }
}
