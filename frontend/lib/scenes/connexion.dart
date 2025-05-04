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
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(response['token'], User.fromJson(response['user']));

      // Redirection basée sur le rôle
      final role = response['user']['role'];
      if (role == 'super_admin' || role == 'moderateur') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/catalogue');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _buildMobileLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: _buildLoginForm(),
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
              child: _buildLoginForm(),
            ),
          ),
        ),
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
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
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
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Mot de passe oublié ?'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child:
                _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Se connecter'),
          ),
          const SizedBox(height: 20),
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
