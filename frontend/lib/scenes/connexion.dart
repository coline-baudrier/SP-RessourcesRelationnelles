import 'package:flutter/material.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/scenes/InscriptionPage.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/auth_provider.dart';
import 'package:frontend/models/user.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Permet de masquer/afficher le mot de passe
  bool _obscurePassword = true;

  // Contrôleurs pour récupérer les valeurs des champs de texte
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Indicateur de chargement pour désactiver les interactions pendant le traitement
  bool _isLoading = false;

  // Fonction de connexion
  Future<void> _handleLogin() async {
    // Vérifie que les champs ne sont pas vides
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Active le loader
    setState(() => _isLoading = true);

    try {
      // Appel du service d'authentification
      final response = await AuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Met à jour le provider avec l'utilisateur connecté
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(response['token'], User.fromJson(response['user']));

      // Redirection selon le rôle
      final role = response['user']['role'];
      if (role == 'super_admin' || role == 'moderateur') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/catalogue');
      }
    } catch (e) {
      // Affiche une erreur en cas d’échec
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      // Désactive le loader
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Nettoie les contrôleurs lorsqu'on quitte la page
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Détection du type d'écran (mobile ou non)
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: isMobile ? _buildMobileLayout() : _buildWebLayout(context),
          ),
          const Footer(),
        ],
      ),
    );
  }

  // Mise en page mobile
  Widget _buildMobileLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: _buildLoginForm(),
      ),
    );
  }

  // Mise en page desktop/web
  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        // Partie gauche : formulaire
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
              child: _buildLoginForm(),
            ),
          ),
        ),
        // Partie droite : image et texte promotionnel
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/famille.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            child: _buildImageOverlayText(),
          ),
        ),
      ],
    );
  }

  // Texte par-dessus l’image (desktop uniquement)
  Widget _buildImageOverlayText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            'Nouveauté :\nDécouvrez la nouvelle catégorie Famille\n'
            'dans les ressources de Ressources Relationnelles.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }

  // Formulaire de connexion (utilisé à la fois sur mobile et desktop)
  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Connexion à Ressources Relationnelles',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Se connecter avec son compte',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Champ Email
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 15),

          // Champ Mot de passe
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

          const SizedBox(height: 10),

          // Lien vers mot de passe oublié
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Mot de passe oublié ?'),
            ),
          ),

          const SizedBox(height: 20),

          // Bouton de connexion
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Se connecter'),
          ),

          const SizedBox(height: 20),

          // Lien vers l’inscription
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InscriptionPage()),
                );
              },
              child: const Text("Vous n'avez pas de compte ? Créer un compte"),
            ),
          ),
        ],
      ),
    );
  }
}