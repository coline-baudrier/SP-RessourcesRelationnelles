import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 850;
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: isMobile ? 16 : 40,
          ),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo à gauche
        Image.asset(
          'assets/images/republique_francaise_rvb.png',
          width: 200,
          height: 200,
        ),

        // Colonne centrale regroupant les deux lignes
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Première ligne - Mentions légales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFooterText('Mentions légales'),
                const SizedBox(width: 24),
                _buildFooterText('Condition d\'utilisation'),
                const SizedBox(width: 24),
                _buildFooterText('Confidentialité'),
              ],
            ),

            const SizedBox(height: 16),

            // Deuxième ligne - Liens utiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFooterLink('legifrance.gouv.fr'),
                const SizedBox(width: 24),
                _buildFooterLink('info.gouv.fr'),
                const SizedBox(width: 24),
                _buildFooterLink('data.gouv.fr'),
              ],
            ),
          ],
        ),

        // Espacement à droite pour équilibrer (peut être remplacé par un widget si nécessaire)
        const SizedBox(width: 120),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Logo en haut
        Image.asset(
          'assets/images/republique_francaise_rvb.png',
          width: 200,
          height: 200,
        ),

        const SizedBox(height: 20),

        // Les deux colonnes côte à côte
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colonne Mentions légales
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFooterText('Mentions légales'),
                const SizedBox(height: 12),
                _buildFooterText('Condition d\'utilisation'),
                const SizedBox(height: 12),
                _buildFooterText('Confidentialité'),
              ],
            ),

            // Colonne Liens utiles
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFooterLink('legifrance.gouv.fr'),
                const SizedBox(height: 12),
                _buildFooterLink('info.gouv.fr'),
                const SizedBox(height: 12),
                _buildFooterLink('data.gouv.fr'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () => debugPrint('$text clicked'),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
