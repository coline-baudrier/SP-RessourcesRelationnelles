import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/user.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/auth_provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user != null) {
      // Si l'utilisateur est déjà dans le provider, utilisez ces données
      setState(() {
        _emailController.text = authProvider.user!.email;
        _nomController.text = authProvider.user!.nom;
        _prenomController.text = authProvider.user!.prenom;
      });
    } else if (authProvider.token != null) {
      // Sinon, chargez le profil depuis l'API
      try {
        User user = await AuthService.getProfile(authProvider.token!);
        authProvider.login(
          authProvider.token!,
          user,
        ); // Mettez à jour le provider
        setState(() {
          _emailController.text = user.email;
          _nomController.text = user.nom;
          _prenomController.text = user.prenom;
        });
      } catch (e) {
        print('Erreur lors du chargement du profil: $e');
      }
    } else {
      print('Utilisateur non connecté');
    }
  }

  Future<void> _changePassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      _showSnackbar('Les mots de passe ne correspondent pas');
      return;
    }

    try {
      await AuthService.resetPassword(_emailController.text, newPassword);
      _showSnackbar('Mot de passe changé avec succès');
    } catch (e) {
      _showSnackbar('Erreur: ${e.toString()}');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mon profil',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField('Email', _emailController),
                        const SizedBox(height: 16),
                        _buildTextField('Nom', _nomController),
                        const SizedBox(height: 16),
                        _buildTextField('Prénom', _prenomController),
                        const SizedBox(height: 24),
                        const Divider(thickness: 1),
                        const SizedBox(height: 24),
                        _buildPasswordField(
                          'Mot de passe actuel',
                          _currentPasswordController,
                          _showPassword,
                          () => setState(() => _showPassword = !_showPassword),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          'Nouveau mot de passe',
                          _newPasswordController,
                          _showNewPassword,
                          () => setState(
                            () => _showNewPassword = !_showNewPassword,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          'Confirmer le mot de passe',
                          _confirmPasswordController,
                          _showConfirmPassword,
                          () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Valider',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool showPassword,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !showPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
