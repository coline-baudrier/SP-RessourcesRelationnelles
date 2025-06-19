import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/services/resource_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/auth_provider.dart';

// ignore: must_be_immutable
class CreationRessourcePage extends StatelessWidget {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController(); // Ajout du controller pour description
  String? _selectedRelation;
  String? _selectedCategorie;
  String? _selectedTypeRessource;

  CreationRessourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer le token depuis AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final token = authProvider.token;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Ajouter une ressource',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Titre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _titreController,
                            decoration: const InputDecoration(
                              hintText: 'Entrez un titre',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Relation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedRelation,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez le type de relation',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                [
                                      'Parents-Enfants',
                                      'Conjoints',
                                      'Frères/Sœurs',
                                      'Amis',
                                      'Collègues',
                                      'Voisins',
                                    ]
                                    .map(
                                      (relation) => DropdownMenuItem(
                                        value: relation,
                                        child: Text(relation),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              _selectedRelation = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Catégorie',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategorie,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez la catégorie',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                [
                                      'Famille',
                                      'Couple',
                                      'Amitié',
                                      'Professionnel',
                                      'Social',
                                    ]
                                    .map(
                                      (categorie) => DropdownMenuItem(
                                        value: categorie,
                                        child: Text(categorie),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              _selectedCategorie = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Type de ressource',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedTypeRessource,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez le type de ressource',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                [
                                      'Article',
                                      'Vidéo',
                                      'Fiche pratique',
                                      'Quiz',
                                      'Témoignage',
                                    ]
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              _selectedTypeRessource = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description', // Titre pour le champ de description
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller:
                                _descriptionController, // Ajout du controller pour la description
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Entrez une description...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Contenu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _contenuController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText:
                                  'Saisissez le contenu de votre ressource...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(thickness: 1),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Color.fromRGBO(0, 0, 145, 1),
                              ),
                              onPressed: () async {
                                Map<String, int> relationIds = {
                                  'Parents-Enfants': 1,
                                  'Conjoints': 2,
                                  'Frères/Sœurs': 3,
                                  'Amis': 4,
                                  'Collègues': 5,
                                  'Voisins': 6,
                                };
                                Map<String, int> categorieIds = {
                                  'Famille': 1,
                                  'Couple': 2,
                                  'Amitié': 3,
                                  'Professionnel': 4,
                                  'Social': 5,
                                };
                                Map<String, int> typeRessourceIds = {
                                  'Article': 1,
                                  'Vidéo': 2,
                                  'Fiche pratique': 3,
                                  'Quiz': 4,
                                  'Témoignage': 5,
                                };

                                // Vérification des champs vides
                                if (_titreController.text.isEmpty ||
                                    _contenuController.text.isEmpty ||
                                    _descriptionController
                                        .text
                                        .isEmpty || // Vérification ajoutée pour la description
                                    _selectedRelation == null ||
                                    _selectedCategorie == null ||
                                    _selectedTypeRessource == null ||
                                    token == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Veuillez remplir tous les champs',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Si la description est vide, on la remplace par une valeur par défaut
                                String description =
                                    _descriptionController.text.isEmpty
                                        ? 'Aucune description fournie'
                                        : _descriptionController.text;

                                try {
                                  await ResourceService.createResource(
                                    titre: _titreController.text,
                                    contenu: _contenuController.text,
                                    token: token,
                                    idTypeRelation:
                                        relationIds[_selectedRelation]!,
                                    idCategorie:
                                        categorieIds[_selectedCategorie]!,
                                    idTypeRessource:
                                        typeRessourceIds[_selectedTypeRessource]!,
                                    statut: 'en_attente',
                                    description:
                                        description, // Envoi de la description ou valeur par défaut
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Ressource créée avec succès',
                                      ),
                                    ),
                                  );

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur: ${e.toString()}'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Publier',
                                style: TextStyle(
                                  fontSize: 16,
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
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
