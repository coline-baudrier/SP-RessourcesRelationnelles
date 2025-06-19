import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/scenes/DetailRessourcePage.dart';
import 'package:frontend/services/resource_service.dart';
import 'package:frontend/models/resource.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  List<Resource> ressources = []; // Liste complète des ressources chargées
  List<Resource> filteredRessources = []; // Liste filtrée selon la recherche
  TextEditingController searchController = TextEditingController(); // Contrôleur pour le champ de recherche

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  // Fonction pour charger les ressources depuis le service
  Future<void> _loadResources() async {
    try {
      final resources = await ResourceService.fetchResources();
      setState(() {
        ressources = resources;
        filteredRessources = ressources;
      });
    } catch (e) {
      // En cas d'erreur, affichage dans la console et réinitialisation des listes
      print('Erreur de chargement: $e');
      setState(() {
        ressources = [];
        filteredRessources = [];
      });
    }
  }

  // Fonction appelée à chaque modification du champ de recherche
  void filterRessources(String query) {
    setState(() {
      filteredRessources = ressources
          .where((item) => item.titre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),

            // Corps principal de la page
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre du catalogue
                          const Center(
                            child: Text(
                              "Catalogue des ressources",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Barre de recherche + bouton filtre (inactif pour l’instant)
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    inputDecorationTheme: const InputDecorationTheme(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(0, 0, 145, 1),
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(0, 0, 145, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: filterRessources,
                                    decoration: const InputDecoration(
                                      hintText: "Rechercher une ressource",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Bouton filtre
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 145, 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.filter_list,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Liste des ressources affichées
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredRessources.length,
                            itemBuilder: (context, index) {
                              final ressource = filteredRessources[index];
                              return InkWell(
                                onTap: () {
                                  // Redirection vers la page de détail de la ressource
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RessourceDetailPage(
                                        resourceId: ressource.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Image de fond
                                        SizedBox(
                                          height: 100,
                                          width: double.infinity,
                                          child: Image.asset(
                                            'assets/images/image.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Flou de fond
                                        Positioned.fill(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                            child: Container(
                                              color: Color.fromRGBO(0, 0, 0, 0.2),
                                            ),
                                          ),
                                        ),
                                        // Titre de la ressource en surimpression
                                        Text(
                                          ressource.titre,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Footer(), // Pied de page
          ],
        ),
      ),
    );
  }
}