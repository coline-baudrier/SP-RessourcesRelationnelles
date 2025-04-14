import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class RessourceDetailPage extends StatelessWidget {
  final String ressourceNom;

  const RessourceDetailPage({
    super.key,
    required this.ressourceNom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header en haut de page (identique au catalogue)
            const Header(),

            // Contenu principal avec défilement
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nom de la ressource
                          Text(
                            ressourceNom,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          // Date de publication
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Publié le 17/12/2024",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Contenu de la ressource
                          const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis. Aliquam sodales, a posuere dui felis et neque. In eu hendrerit diam.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          
                          // Auteur
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              "@TomLeRoux",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          
                          const Divider(height: 40),
                          
                          // Section Commentaires
                          const Text(
                            "Commentaires (1)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Commentaire
                          const Text(
                            "Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          
                          // Auteur du commentaire
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "@TomLeRoux",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Footer en bas de page (identique au catalogue)
            const Footer(),
          ],
        ),
      ),
    );
  }
}