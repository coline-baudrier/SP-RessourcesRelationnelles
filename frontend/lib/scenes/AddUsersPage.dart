import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/services/admin_user_service.dart';
import 'package:frontend/services/auth_provider.dart';

// Page d'ajout d'utilisateur avec formulaire
class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Valeur sélectionnée dans la liste des rôles
  String _selectedRole = 'citoyen';

  // Indicateur de chargement
  bool _isLoading = false;

  // Liste des rôles disponibles
  final List<String> _roles = ['citoyen', 'moderateur', 'super_admin'];

  @override
  void dispose() {
    // Libération des ressources des contrôleurs à la destruction du widget
    _emailController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fonction appelée lors de la soumission du formulaire
  Future<void> _submitForm(BuildContext context) async {
    // Validation du formulaire
    if (!_formKey.currentState!.validate()) return;

    // Vérification de la correspondance des mots de passe
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Récupération du token via le provider d'authentification
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Appel du service pour créer un utilisateur
      await AdminUserService.createUser(
        authProvider.token!,
        _emailController.text,
        _passwordController.text,
        _nomController.text,
        _prenomController.text,
        _selectedRole,
      );

      // Affichage d'un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur créé avec succès')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      // Affichage de l'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Champ Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      // Champ Nom
                      TextFormField(
                        controller: _nomController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      // Champ Prénom
                      TextFormField(
                        controller: _prenomController,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prénom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Champs de mot de passe et confirmation
                      _PasswordFields(
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                      ),
                      const SizedBox(height: 8),

                      // Sélection du rôle
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(labelText: 'Rôle'),
                        items: _roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un rôle';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Bouton de validation
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                          ),
                          onPressed: _isLoading ? null : () => _submitForm(context),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Ajouter',
                                  style: TextStyle(fontSize: 16),
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
    );
  }
}

// Widget dédié à la gestion des champs de mot de passe
class _PasswordFields extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _PasswordFields({
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<_PasswordFields> createState() => _PasswordFieldsState();
}

class _PasswordFieldsState extends State<_PasswordFields> {
  // Gestion de la visibilité des champs
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Champ mot de passe
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un mot de passe';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit faire au moins 6 caractères';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        // Champ confirmation du mot de passe
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez confirmer le mot de passe';
            }
            return null;
          },
        ),
      ],
    );
  }
}
