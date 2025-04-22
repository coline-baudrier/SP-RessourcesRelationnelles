import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Column(
      children: [
        // Header pour les écrans desktop et mobile
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 10,
          ),
          child:
              isDesktop
                  ? _buildDesktopHeader(context)
                  : _buildMobileHeader(context),
        ),
        if (isDesktop)
          _buildNavBar(context), // Barre de navigation pour les écrans desktop
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/republique_francaise_rvb.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Le site officiel du ministre",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "des solidarités et de la santé",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/login',
            ); // Lien vers la page de connexion
          },
          child: const Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 8),
              Text("Se connecter", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/republique_francaise_rvb.png',
          width: 80,
          height: 80,
        ),
        IconButton(
          icon: const Icon(Icons.menu, size: 32),
          onPressed: () => _showMobileMenu(context),
        ),
      ],
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.grey),
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavItem(context, "Catalogue", '/catalogue'),
                _buildNavItem(context, "Ajouter une Ressource", '/ajouter'),
                _buildNavItem(context, "Modération", '/moderation'),
                _buildNavItem(context, "Accessibilité", '/accessibilite'),
                _buildNavItem(context, "Profil", '/profil'),
                _buildNavItem(context, "Tableau de bord", '/dashboard'),
                _buildNavItem(context, "Contactez-nous", '/contact'),
                _buildNavItem(context, "Aide", '/aide'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    String route, {
    bool isBold = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black, // Le texte reste en noir
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _menuItem(context, Icons.book, "Catalogue", '/catalogue'),
                      _menuItem(
                        context,
                        Icons.add,
                        "Ajouter une Ressource",
                        '/ajouter',
                      ),
                      _menuItem(
                        context,
                        Icons.admin_panel_settings,
                        "Modération",
                        '/moderation',
                      ),
                      _menuItem(
                        context,
                        Icons.accessibility,
                        "Accessibilité",
                        '/accessibilite',
                      ),
                      _menuItem(context, Icons.person, "Profil", '/profil'),
                      _menuItem(
                        context,
                        Icons.dashboard,
                        "Tableau de bord",
                        '/dashboard',
                      ),
                      _menuItem(
                        context,
                        Icons.mail,
                        "Contactez-nous",
                        '/contact',
                      ),
                      _menuItem(context, Icons.help, "Aide", '/aide'),
                      _menuItem(
                        context,
                        Icons.login,
                        "Se connecter",
                        '/login',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: () {
        Navigator.pop(context); // Ferme le menu mobile
        Navigator.pushNamed(
          context,
          route,
        ); // Navigue vers la page correspondante
      },
    );
  }
}
