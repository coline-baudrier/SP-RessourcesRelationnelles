import 'package:flutter/material.dart';
import 'scenes/connexion.dart'; // Assurez-vous d'importer votre page de connexion
import 'package:frontend/scenes/catalogue.dart';
import 'package:frontend/scenes/IncriptionPage.dart';
import 'package:frontend/scenes/validation_ressources.dart';
import 'package:frontend/scenes/profil_page.dart';
import 'package:frontend/scenes/tableau_de_bord_page.dart';
import 'package:frontend/scenes/MenuModerPage.dart';
import 'package:frontend/scenes/creation-ressource.dart';

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
