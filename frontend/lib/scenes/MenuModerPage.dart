import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/scenes/GestionUsersPage.dart';
import 'package:frontend/scenes/AddUsersPage.dart';
import 'package:frontend/scenes/ValidationRessourcePage.dart';
import 'package:frontend/scenes/StatistiquePage.dart';

class MenuModerPage extends StatelessWidget {
  const MenuModerPage({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final cardWidth = isMobile ? constraints.maxWidth * 0.8 : 500.0;

          return Column(
            children: [
              const Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "Menu de modération",
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _MenuCard(
                                icon: Icons.book,
                                text: 'Gestion des ressources',
                                width: cardWidth,
                                onTap: () {
                                  navigateTo(
                                    context,
                                    ValidationRessourcesPage(),
                                  );
                                },
                              ),
                              _MenuCard(
                                icon: Icons.supervised_user_circle_outlined,
                                text: 'Gestion des utilisateurs',
                                width: cardWidth,
                                onTap: () {
                                  navigateTo(context, GestionUsersPage());
                                },
                              ),
                              _MenuCard(
                                icon: Icons.library_books_outlined,
                                text: "Ajout d'utilisateurs",
                                width: cardWidth,
                                onTap: () {
                                  navigateTo(context, AddUserPage());
                                },
                              ),
                              _MenuCard(
                                icon: Icons.assessment,
                                text: "Statistiques",
                                width: cardWidth,
                                onTap: () {
                                  navigateTo(context, StatistiquePage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const Footer(),
            ],
          );
        },
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final double width;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.text,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.black),
                const SizedBox(height: 8),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
