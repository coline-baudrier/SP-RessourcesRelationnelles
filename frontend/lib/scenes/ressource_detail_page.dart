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
            // Header en haut de page
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
                          
                          // Ligne avec nom de la ressource, bouton supprimer et catégorie
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
                              
                              // Bouton Supprimer
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 22),
                                onPressed: () {},
                                color: Colors.grey[600],
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
                          
                          // Boutons d'interaction
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionButton(
                                  icon: Icons.favorite_border,
                                  label: "J'aime",
                                ),
                                _buildActionButton(
                                  icon: Icons.share,
                                  label: "Partager",
                                ),
                                _buildActionButton(
                                  icon: Icons.bookmark_border,
                                  label: "Enregistrer",
                                ),
                              ],
                            ),
                          ),
                          
                          const Divider(height: 1),
                          
                          // Section Commentaires
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Commentaires (2)",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Supprimer un commentaire",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Premier commentaire
                          _buildComment(
                            content: "Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis",
                            author: "@TomLeRoux",
                            showDelete: true,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Deuxième commentaire
                          _buildComment(
                            content: "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae. Nullam at efficitur libero.",
                            author: "@MarieDupont",
                            showDelete: true,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Champ pour écrire un commentaire
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Écrire un commentaire...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {},
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

            // Footer en bas de page
            const Footer(),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable pour les boutons d'action
  Widget _buildActionButton({required IconData icon, required String label}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
          color: Colors.blue,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  // Widget réutilisable pour les commentaires (version améliorée)
  Widget _buildComment({
    required String content, 
    required String author,
    bool showDelete = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                ),
              ),
              if (showDelete)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}