import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ajouter un utilisateur',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Identifiant',
                              ),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Nom',
                              ),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Prénom',
                              ),
                            ),
                            const SizedBox(height: 8),
                            const _PasswordFields(),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Rôle',
                              ),
                              items:
                                  [
                                        'Admin',
                                        'Utilisateur',
                                        'Utilisateur non connecté',
                                      ]
                                      .map(
                                        (role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: 16),
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
                                onPressed: () {},
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
                ),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class _PasswordFields extends StatefulWidget {
  const _PasswordFields();

  @override
  State<_PasswordFields> createState() => _PasswordFieldsState();
}

class _PasswordFieldsState extends State<_PasswordFields> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
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
        const SizedBox(height: 8),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
        ),
      ],
    );
  }
}
