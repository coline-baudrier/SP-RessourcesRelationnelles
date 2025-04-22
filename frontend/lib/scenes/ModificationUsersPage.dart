import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class ModificationUsersPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ModificationUsersPage({super.key, required this.user});

  @override
  State<ModificationUsersPage> createState() => _ModificationUsersPageState();
}

class _ModificationUsersPageState extends State<ModificationUsersPage> {
  late TextEditingController prenomController;
  late TextEditingController nomController;
  late TextEditingController emailController;
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();
    prenomController = TextEditingController(text: widget.user['prénom']);
    nomController = TextEditingController(text: widget.user['nom']);
    emailController = TextEditingController(text: widget.user['email']);
    roleController = TextEditingController(text: widget.user['role']);
  }

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  void _validerModifications() {
    final updatedUser = {
      'prénom': prenomController.text,
      'nom': nomController.text,
      'email': emailController.text,
      'role': roleController.text,
    };

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),
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
                  'Modifier l’utilisateur',
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
                      controller: prenomController,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nomController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: roleController,
                      decoration: const InputDecoration(labelText: 'Rôle'),
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
          Footer(),
        ],
      ),
    );
  }
}
