import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController _emailController = TextEditingController(text: 'tomleroux@gouv.fr');
  final TextEditingController _nomController = TextEditingController(text: 'le roux');
  final TextEditingController _prenomController = TextEditingController(text: 'Tom');
  final TextEditingController _phoneController = TextEditingController(text: '06 88 23 56 12');
  final TextEditingController _adresseController = TextEditingController(text: '16 route de Lannion, Bégard 22420');
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                        
                        // Section informations personnelles
                        _buildTextField('Email', _emailController),
                        const SizedBox(height: 16),
                        _buildTextField('Nom', _nomController),
                        const SizedBox(height: 16),
                        _buildTextField('Prénom', _prenomController),
                        const SizedBox(height: 16),
                        _buildTextField('Téléphone', _phoneController),
                        const SizedBox(height: 16),
                        _buildTextField('Adresse', _adresseController),
                        
                        const SizedBox(height: 24),
                        const Divider(thickness: 1),
                        const SizedBox(height: 24),
                        
                        // Section mot de passe
                        _buildPasswordField('Mot de passe actuel', _currentPasswordController, _showPassword, 
                          () => setState(() => _showPassword = !_showPassword)),
                        const SizedBox(height: 16),
                        _buildPasswordField('Nouveau mot de passe', _newPasswordController, _showNewPassword, 
                          () => setState(() => _showNewPassword = !_showNewPassword)),
                        const SizedBox(height: 16),
                        _buildPasswordField('Confirmer le mot de passe', _confirmPasswordController, _showConfirmPassword, 
                          () => setState(() => _showConfirmPassword = !_showConfirmPassword)),
                        
                        const SizedBox(height: 40),
                        
                        // Bouton Valider
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Logique de validation
                            },
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !showPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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