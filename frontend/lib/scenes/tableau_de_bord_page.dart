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
                    constraints: const BoxConstraints(maxWidth: 800),
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
                        _buildStatItem(Icons.bookmark, 'Vous avez sauvegardé 20 fois cette semaine'),
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
                        _buildResourceCard('Ressource 1', screenWidth),
                        _buildResourceCard('Ressource 2', screenWidth),

                        _buildSectionTitle('Vos ressources favorites :'),
                        _buildResourceCard('Ressource 1', screenWidth),
                        _buildResourceCard('Ressource 2', screenWidth),

                        _buildSectionTitle('Votre historique :'),
                        _buildResourceCard('Ressource 1', screenWidth),
                        _buildResourceCard('Ressource 2', screenWidth),
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

  Widget _buildResourceCard(String title, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: screenWidth < 600 ? double.infinity : 800,
          minHeight: 100,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
