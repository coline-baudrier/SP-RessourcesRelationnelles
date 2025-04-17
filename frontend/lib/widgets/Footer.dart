import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 850;

        if (isMobile) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: _buildDesktopLayout(),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/republique_francaise_rvb.png',
          width: 100,
          height: 100,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        const SizedBox(width: 120),
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
