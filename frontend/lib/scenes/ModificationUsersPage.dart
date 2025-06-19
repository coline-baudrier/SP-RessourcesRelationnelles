import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/models/user.dart';

class ModificationUsersPage extends StatefulWidget {
  final User user;
  final Function(User) onUserUpdated;

  const ModificationUsersPage({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ModificationUsersPage> createState() => _ModificationUsersPageState();
}

class _ModificationUsersPageState extends State<ModificationUsersPage> {
  late TextEditingController _prenomController;
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late String _selectedRole;
  final List<String> _availableRoles = ['citoyen', 'moderateur', 'super_admin'];

  @override
  void initState() {
    super.initState();
    _prenomController = TextEditingController(text: widget.user.prenom);
    _nomController = TextEditingController(text: widget.user.nom);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _validerModifications() async {
    final updatedUser = User(
      id: widget.user.id,
      email: _emailController.text,
      nom: _nomController.text,
      prenom: _prenomController.text,
      role: _selectedRole,
      compteActif: widget.user.compteActif,
    );

    widget.onUserUpdated(updatedUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Modifier l\'utilisateur',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextField(
                      controller: _prenomController,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Rôle'),
                      items:
                          _availableRoles.map((role) {
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
                    ),
                    const SizedBox(height: 24),
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
                        onPressed: _validerModifications,
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
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
