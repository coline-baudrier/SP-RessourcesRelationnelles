import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/auth_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 10,
          ),
          child:
              isDesktop
                  ? _buildDesktopHeader(context, authProvider)
                  : _buildMobileHeader(context, authProvider),
        ),
        if (isDesktop) _buildNavBar(context, authProvider),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context, AuthProvider authProvider) {
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
                  "Le site officiel du Ministre",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "des Solidarités et de la Santé",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        if (!authProvider.isAuthenticated)
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Row(
              children: [
                Icon(Icons.person_outline),
                SizedBox(width: 8),
                Text("Se connecter", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        if (authProvider.isAuthenticated)
          Row(
            children: [
              Text(
                'Bonjour, ${authProvider.user?.prenom}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profil');
                },
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Déconnexion',
                onPressed: () => _confirmLogout(context, authProvider),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context, AuthProvider authProvider) {
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
          onPressed: () => _showMobileMenu(context, authProvider),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer la déconnexion'),
            content: const Text('Voulez-vous vraiment vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      authProvider.logout();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildNavBar(BuildContext context, AuthProvider authProvider) {
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
                if (authProvider.isAuthenticated)
                  _buildNavItem(context, "Ajouter une Ressource", '/ajouter'),
                if (authProvider.user?.role == 'moderateur' ||
                    authProvider.user?.role == 'super_admin')
                  _buildNavItem(context, "Modération", '/moderation'),
                if (authProvider.isAuthenticated)
                  _buildNavItem(context, "Profil", '/profil'),
                if (authProvider.user?.role == 'citoyen')
                  _buildNavItem(context, "Tableau de bord", '/dashboard'),
                if (!authProvider.isAuthenticated)
                  _buildNavItem(context, "Se connecter", '/login'),
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
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context, AuthProvider authProvider) {
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
                      if (authProvider.isAuthenticated)
                        _menuItem(
                          context,
                          Icons.add,
                          "Ajouter une Ressource",
                          '/ajouter',
                        ),
                      if (authProvider.user?.role == 'moderateur' ||
                          authProvider.user?.role == 'super_admin')
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
                      if (authProvider.isAuthenticated)
                        _menuItem(context, Icons.person, "Profil", '/profil'),
                      if (authProvider.isAuthenticated)
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
                      if (authProvider.isAuthenticated)
                        _menuItem(
                          context,
                          Icons.logout,
                          "Se déconnecter",
                          '',
                          color: Colors.red,
                          onTap: () async {
                            Navigator.pop(context);
                            await _confirmLogout(context, authProvider);
                          },
                        ),
                      if (!authProvider.isAuthenticated)
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
    Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            if (route.isNotEmpty) {
              Navigator.pushNamed(context, route);
            }
          },
    );
  }
}
