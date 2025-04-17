import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/scenes/ModificationUsersPage.dart';

class GestionUsersPage extends StatelessWidget {
  final List<Map<String, dynamic>> utilisateurs = [
    {
      'utilisateur': 'tomlrx',
      'prénom': 'Tom',
      'nom': 'Lrx',
      'role': 'Admin',
      'email': 'tom@tom.com',
    },
    {
      'utilisateur': 'guillaumeg',
      'prénom': 'Guillaume',
      'nom': 'G.',
      'role': 'Utilisateur',
      'email': 'guigui@guigui.com',
    },
    {
      'utilisateur': 'colineb',
      'prénom': 'Coline',
      'nom': 'Baudrier',
      'role': 'Utilisateur non connecté',
      'email': 'coline@coline.com',
    },
  ];

  GestionUsersPage({super.key});

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
                  'Gestion des utilisateurs',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: utilisateurs.length,
                  itemBuilder: (context, index) {
                    final user = utilisateurs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          '${user['prénom']} ${user['nom']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('${user['role']}')],
                        ),
                        isThreeLine: true,
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ModificationUsersPage(user: user),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
