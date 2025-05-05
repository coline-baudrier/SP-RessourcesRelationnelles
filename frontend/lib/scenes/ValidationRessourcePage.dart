import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/models/resource.dart';
import 'package:frontend/services/admin_resource_service.dart';
import 'package:frontend/services/auth_provider.dart';

class ValidationRessourcesPage extends StatefulWidget {
  const ValidationRessourcesPage({super.key});

  @override
  State<ValidationRessourcesPage> createState() =>
      _ValidationRessourcesPageState();
}

class _ValidationRessourcesPageState extends State<ValidationRessourcesPage> {
  late Future<List<Resource>> _pendingResources;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadPendingResources();
  }

  void _loadPendingResources() {
    print(
      'Token envoyé: ${_authProvider.token}',
    ); // Affiche le token dans la console
    setState(() {
      _pendingResources = AdminResourceService.getPendingResources(
        _authProvider.token!,
      );
    });
  }

  Future<void> _approveResource(int resourceId) async {
    try {
      await AdminResourceService.approveResource(
        resourceId,
        _authProvider.token!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ressource approuvée avec succès')),
      );
      _loadPendingResources();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }

  Future<void> _rejectResource(int resourceId) async {
    try {
      await AdminResourceService.rejectResource(
        resourceId,
        _authProvider.token!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ressource rejetée avec succès')),
      );
      _loadPendingResources();
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
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: FutureBuilder<List<Resource>>(
                  future: _pendingResources,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune ressource en attente de validation',
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Gestion des ressources en attente',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ...snapshot.data!.map((resource) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      resource.titre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '@${resource.createurPrenom}${resource.createurNom}',
                                      ),
                                      const Spacer(),
                                      Text(resource.dateCreation),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue[100],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.people_outline,
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              resource.nomCategorie,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(resource.contenu),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed:
                                            () => _rejectResource(resource.id),
                                        child: const Text('Refuser'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed:
                                            () => _approveResource(resource.id),
                                        child: const Text('Accepter'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
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
