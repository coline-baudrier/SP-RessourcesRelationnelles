// lib/models/resource.dart
class Resource {
  final int id;
  final String titre;
  final String description;
  final String contenu;
  final String dateCreation;
  final String createurNom;
  final String createurPrenom;
  final String nomCategorie;
  final String typeRessource;
  final List<Map<String, dynamic>> relations;

  Resource({
    required this.id,
    required this.titre,
    required this.description,
    required this.contenu,
    required this.dateCreation,
    required this.createurNom,
    required this.createurPrenom,
    required this.nomCategorie,
    required this.typeRessource,
    required this.relations,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id_ressource'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      contenu: json['contenu'] ?? '',
      dateCreation: json['date_creation'] ?? '',
      createurNom: json['createur_nom'] ?? '',
      createurPrenom: json['createur_prenom'] ?? '',
      nomCategorie: json['nom_categorie'] ?? '',
      typeRessource: json['type_ressource'] ?? '',
      relations:
          (json['relations'] as List<dynamic>?)?.map((relation) {
            return {
              'id': relation['id_type_relation'],
              'nom': relation['nom_relation'],
            };
          }).toList() ??
          [],
    );
  }
}
