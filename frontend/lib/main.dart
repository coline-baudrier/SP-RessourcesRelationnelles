import 'package:flutter/material.dart';
import 'package:frontend/scenes/MenuModerPage.dart';
import 'package:frontend/scenes/catalogue.dart';
import 'package:frontend/scenes/creation-ressource.dart';
import 'package:frontend/scenes/connexion.dart';
import 'package:frontend/scenes/TableauBordPage.dart';

import 'package:frontend/scenes/ProfilPage.dart'; // Si tu as une page de connexion

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/catalogue',
      routes: {
        '/catalogue': (context) => Catalogue(),
        '/ajouter': (context) => CreationRessourcePage(),
        '/moderation': (context) => MenuModerPage(),
        '/profil': (context) => ProfilPage(),
        '/dashboard': (context) => TableauDeBordPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
