import 'package:flutter/material.dart';
import 'package:frontend/scenes/ModificationUsersPage.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/admin_user_service.dart';
import 'package:frontend/services/auth_provider.dart';

class GestionUsersPage extends StatefulWidget {
  const GestionUsersPage({super.key});

  @override
  State<GestionUsersPage> createState() => _GestionUsersPageState();
}

class _GestionUsersPageState extends State<GestionUsersPage> {
  late Future<List<User>> _usersFuture;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = AdminUserService.getAllUsers(_authProvider.token!);
    });
  }

  Future<void> _toggleUserStatus(int userId) async {
    try {
      await AdminUserService.toggleUserStatus(_authProvider.token!, userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Statut utilisateur modifié')),
      );
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
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
                  'Gestion des utilisateurs',
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
                child: FutureBuilder<List<User>>(
                  future: _usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Aucun utilisateur trouvé'),
                      );
                    }

                    final users = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              '${user.prenom} ${user.nom}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(user.role), Text(user.email)],
                            ),
                            isThreeLine: true,
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ModificationUsersPage(
                                              user: user,
                                              onUserUpdated: (
                                                updatedUser,
                                              ) async {
                                                try {
                                                  // Appel au service pour mettre à jour le rôle
                                                  await AdminUserService.updateUserRole(
                                                    _authProvider.token!,
                                                    updatedUser.id,
                                                    updatedUser.role,
                                                  );

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Rôle utilisateur mis à jour',
                                                      ),
                                                    ),
                                                  );
                                                  _loadUsers(); // Recharger la liste
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Erreur: ${e.toString()}',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    user.compteActif ?? true
                                        ? Icons.toggle_on
                                        : Icons.toggle_off,
                                    color:
                                        user.compteActif ?? true
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  onPressed: () => _toggleUserStatus(user.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
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
