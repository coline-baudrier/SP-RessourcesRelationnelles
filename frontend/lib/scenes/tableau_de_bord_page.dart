import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class TableauDeBordPage extends StatelessWidget {
  const TableauDeBordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'En bref :',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildStatItem(Icons.favorite, '+ 52 j\'aimes cette semaine sur vos ressources'),
                        _buildStatItem(Icons.comment, 'Vous avez commenté 12 fois cette semaine'),
                        _buildStatItem(Icons.bookmark, 'Vous avez sauvegardez 20 fois cette semaine'),
                        _buildStatItem(Icons.flag, 'Vous avez signalé 0 fois cette semaine'),
                        
                        const SizedBox(height: 40),
                        const Text(
                          'Tableau de bord',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildSectionTitle('Vos ressources :'),
                        _buildResourceCardWithImage('Ressource 1'),
                        _buildResourceCardWithImage('Ressource 2'),

                        _buildSectionTitle('Vos ressources favorites :'),
                        _buildResourceCardWithImage('Ressource 1'),
                        _buildResourceCardWithImage('Ressource 2'),

                        _buildSectionTitle('Votre historique :'),
                        _buildResourceCardWithImage('Ressource 1'),
                        _buildResourceCardWithImage('Ressource 2'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildResourceCardWithImage(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigation vers le détail de la ressource
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image de fond floutée
                Image.asset(
                  'assets/images/image.jpg', // Remplacez par votre image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Effet de flou
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                // Titre de la ressource
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}