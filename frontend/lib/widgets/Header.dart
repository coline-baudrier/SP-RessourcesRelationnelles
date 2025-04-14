import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;
    final isMediumScreen = screenWidth < 1304 && screenWidth >= 800;

    return Column(
      children: [
        // Partie supérieure avec logo et titre
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 10,
          ),
          child:
              isDesktop ? _buildDesktopHeader() : _buildMobileHeader(context),
        ),

        // Barre de navigation
        if (isDesktop) _buildResponsiveNavBar(context, isMediumScreen),
      ],
    );
  }

  Widget _buildDesktopHeader() {
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
        const Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 8),
            Text("Se connecter", style: TextStyle(fontSize: 18)),
          ],
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

  Widget _buildResponsiveNavBar(BuildContext context, bool isMediumScreen) {
    final navItems = [
      _NavItem(null, "Catalogue des Ressources", "Catalogue"),
      _NavItem(null, "Ajouter une ressource", "Ajouter"),
      _NavItem(null, "Modération", "Modération"),
      _NavItem(null, "Accessibilité", "Accessibilité"),
      _NavItem(null, "Profil", "Profil"),
      _NavItem(null, "Tableau de bord", "Tableau"),
      _NavItem(null, "Contactez nous", "Contact"),
      _NavItem(null, "Aide", "Aide"),
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.grey),
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    navItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildNavItem(
                          item.icon,
                          isMediumScreen ? item.shortLabel : item.fullLabel,
                          tooltip: item.fullLabel,
                          fontSize: 16,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData? icon,
    String label, {
    String? tooltip,
    double fontSize = 16,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, size: fontSize + 2),
              if (icon != null) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
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
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildMobileMenuItem(
                        context,
                        Icons.book_outlined,
                        "Catalogue des Ressources",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.add_circle_outline,
                        "Ajouter une Ressource",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.admin_panel_settings_outlined,
                        "Modération",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.person_outline,
                        "Profil",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.dashboard_outlined,
                        "Tableau de bord",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.mail_outline,
                        "Contactez nous",
                      ),
                      _buildMobileMenuItem(
                        context,
                        Icons.accessibility_outlined,
                        "Accessibilité",
                      ),
                      _buildMobileMenuItem(context, Icons.help_outline, "Aide"),
                      const SizedBox(height: 16),
                      _buildMobileMenuItem(
                        context,
                        Icons.login,
                        "Se connecter",
                        color: Colors.blue,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),
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

  Widget _buildMobileMenuItem(
    BuildContext context,
    IconData icon,
    String label, {
    Color color = Colors.black,
    bool isBold = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Navigation à implémenter
      },
    );
  }
}

class _NavItem {
  final IconData? icon;
  final String fullLabel;
  final String shortLabel;

  _NavItem(this.icon, this.fullLabel, this.shortLabel);
}
