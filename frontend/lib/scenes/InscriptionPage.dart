import 'package:flutter/material.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/widgets/Header.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  bool _obscurePassword = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: isMobile ? _buildMobileLayout() : _buildWebLayout(context),
          ),
          Footer(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: _buildInscriptionForm(),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
              child: _buildInscriptionForm(),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/famille.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.7),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInscriptionForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Inscription à Ressources Relationnelles',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Créer votre compte',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Identifiant',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Prénom',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Vérification du mot de passe',
              border: const OutlineInputBorder(),
              errorText: _passwordError,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  _passwordError = 'Les mots de passe ne correspondent pas';
                } else {
                  _passwordError = null;
                  // Lancer l'inscription ici
                  print("Mot de passe confirmé !");
                }
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text("S'inscrire"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
