import 'package:flutter/material.dart';
import 'package:frontend/scenes/MenuModerPage.dart';
import 'package:frontend/scenes/catalogue.dart';
import 'package:frontend/scenes/creation-ressource.dart';
import 'package:frontend/scenes/connexion.dart';
import 'package:frontend/scenes/TableauBordPage.dart';
import 'package:frontend/scenes/ProfilPage.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => AuthProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          '/catalogue', // L'utilisateur arrive directement sur la page Catalogue
      routes: {
        '/login': (context) => const LoginPage(),
        '/catalogue': (context) => const Catalogue(),
        '/ajouter': (context) => CreationRessourcePage(),
        '/moderation': (context) => const MenuModerPage(),
        '/profil': (context) => const ProfilPage(),
        '/dashboard': (context) => const TableauDeBordPage(),
      },
      onGenerateRoute: (settings) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // Si non connecté, rediriger vers login ou permettre de voir uniquement le catalogue
        if (!authProvider.isAuthenticated) {
          if (settings.name != '/login') {
            return MaterialPageRoute(builder: (context) => const Catalogue());
          }
        }

        // Gestion des accès par rôle
        if (authProvider.isAuthenticated) {
          final userRole = authProvider.user?.role;

          switch (settings.name) {
            // Pages accessibles à tous les utilisateurs connectés
            case '/catalogue':
              return MaterialPageRoute(builder: (context) => const Catalogue());

            // Pages accessibles aux citoyens
            case '/ajouter':
            case '/profil':
            case '/dashboard':
              if (userRole == 'citoyen') {
                return MaterialPageRoute(
                  builder:
                      (context) =>
                          settings.name == '/ajouter'
                              ? CreationRessourcePage()
                              : (settings.name == '/profil'
                                  ? ProfilPage()
                                  : TableauDeBordPage()),
                );
              }
              break;

            // Pages accessibles aux modérateurs et super admins
            case '/moderation':
              if (userRole == 'moderateur' || userRole == 'super_admin') {
                return MaterialPageRoute(
                  builder: (context) => const MenuModerPage(),
                );
              }
              break;
          }
        }

        return null; // Laisser le système de route gérer normalement
      },
    );
  }
}
