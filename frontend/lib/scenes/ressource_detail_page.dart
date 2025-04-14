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
                          // Bouton de retour
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          
                          // Ligne avec nom de la ressource et catégorie
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Nom de la ressource
                              Expanded(
                                child: Text(
                                  ressourceNom,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              // Bouton de catégorie
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.people_outline,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Catégorie",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            "Commentaires (2)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Premier commentaire
                          _buildComment(
                            content: "Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis",
                            author: "@TomLeRoux",
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Deuxième commentaire
                          _buildComment(
                            content: "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae. Nullam at efficitur libero.",
                            author: "@MarieDupont",
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

  // Widget réutilisable pour les commentaires
  Widget _buildComment({required String content, required String author}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            author,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}