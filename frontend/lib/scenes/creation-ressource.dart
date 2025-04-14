import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class CreationRessourcePage extends StatelessWidget {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  String? _selectedRelation;
  String? _selectedCategorie;
  String? _selectedStatut;

  CreationRessourcePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedRelation,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez le type de relation',
                              border: OutlineInputBorder(),
                            ),
                            items: ['Relation 1', 'Relation 2', 'Relation 3']
                                .map((relation) => DropdownMenuItem(
                                      value: relation,
                                      child: Text(relation),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _selectedRelation = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Catégorie',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategorie,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez la catégorie',
                              border: OutlineInputBorder(),
                            ),
                            items: ['Catégorie 1', 'Catégorie 2', 'Catégorie 3']
                                .map((categorie) => DropdownMenuItem(
                                      value: categorie,
                                      child: Text(categorie),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _selectedCategorie = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Statut',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedStatut,
                            decoration: const InputDecoration(
                              hintText: 'Choisissez le statut',
                              border: OutlineInputBorder(),
                            ),
                            items: ['Statut 1', 'Statut 2', 'Statut 3']
                                .map((statut) => DropdownMenuItem(
                                      value: statut,
                                      child: Text(statut),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _selectedStatut = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Contenu',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _contenuController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Saisissez le contenu de votre ressource...',
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
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Color.fromRGBO(0, 0, 145, 1),
                              ),
                              onPressed: () {
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