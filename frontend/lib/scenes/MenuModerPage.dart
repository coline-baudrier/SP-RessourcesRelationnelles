import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/scenes/GestionUsersPage.dart';
import 'package:frontend/scenes/AddUsersPage.dart';

class MenuModerPage extends StatelessWidget {
  const MenuModerPage({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 30), // Espace après le header
          const Text("Menu de modération", style: TextStyle(fontSize: 25)),
          const SizedBox(height: 30),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final cardWidth = isMobile ? constraints.maxWidth * 0.8 : 250.0;

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _MenuCard(
                          icon: Icons.book,
                          text: 'Gestion des ressources',
                          isMobile: isMobile,
                          width: isMobile ? cardWidth : 500,
                          onTap: () {},
                        ),
                        _MenuCard(
                          icon: Icons.supervised_user_circle_outlined,
                          text: 'Gestion des utilisateurs',
                          isMobile: isMobile,
                          width: isMobile ? cardWidth : 500,
                          onTap: () {
                            navigateTo(context, GestionUsersPage());
                          },
                        ),
                        _MenuCard(
                          icon: Icons.library_books_outlined,
                          text: "Ajout d'utilisateurs",
                          isMobile: isMobile,
                          width: isMobile ? cardWidth : 500,
                          onTap: () {
                            navigateTo(context, AddUserPage());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isMobile;
  final double width;

  const _MenuCard({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isMobile,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // Carte en blanc
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          height: isMobile ? 100 : 150,
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey), // Bordure grise
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isMobile ? 36 : 48,
                color: Colors.black,
              ), // Icône noire
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Bienvenue sur la page $title')),
    );
  }
}
