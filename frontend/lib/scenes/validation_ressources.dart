import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';

class ValidationRessourcesPage extends StatelessWidget {
  final List<Map<String, dynamic>> ressources = [
    {
      'titre': 'Titre de la ressource',
      'auteur': '@FranceGouv',
      'date': '21/03/2025',
      'tags': ['Travail'],
      'contenu':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.',
    },
    {
      'titre': 'Titre de la ressource',
      'auteur': '@FranckB',
      'date': '01/01/2025',
      'tags': ['Collegues'],
      'contenu':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.',
    },
    {
      'titre': 'Titre de la ressource',
      'auteur': '@TomLeRoux',
      'date': '20/12/2024',
      'tags': ['Travail', 'Collegues'],
      'contenu':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in arcu sed nisi dapibus cursus. Aliquam id mi tellus. Sed nec elementum ante, ac vestibulum diam. Donec aliquam lorem vestibulum quam lobortis venenatis.',
    },
  ];

  ValidationRessourcesPage({super.key});

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
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Gestion des ressources',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ...ressources.map((ressource) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ressource['titre'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            if (ressource['auteur'] != null && ressource['date'] != null) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Text(ressource['auteur'] ?? ''),
                                    const Spacer(),
                                    Text(ressource['date'] ?? ''),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (ressource['tags'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.people_outline,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Catégorie",
                                            style: TextStyle(
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
                            if (ressource['contenu'] != null) ...[
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(ressource['contenu'] ?? ''),
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
                                      onPressed: () {},
                                      child: const Text('Refuser'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {},
                                      child: const Text('Accepter'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    }).toList(),
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
