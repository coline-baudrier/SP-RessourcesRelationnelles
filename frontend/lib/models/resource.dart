class Resource {
  final int id;
  final String titre;
  final String description;
  final String contenu;
  final String dateCreation;
  final String createurNom;
  final String createurPrenom;
  final int? createurId;
  final String nomCategorie;
  final String typeRessource;
  final List<Map<String, dynamic>> relations;
  final String statut; // Ajouté

  Resource({
    required this.id,
    required this.titre,
    required this.description,
    required this.contenu,
    required this.dateCreation,
    required this.createurNom,
    required this.createurPrenom,
    this.createurId,
    required this.nomCategorie,
    required this.typeRessource,
    required this.relations,
    required this.statut, // Ajouté
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: int.parse(json['id_ressource'].toString()),
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      contenu: json['contenu'] ?? '',
      dateCreation: json['date_creation']?.toString() ?? '',
      createurNom: json['createur_nom'] ?? '',
      createurPrenom: json['createur_prenom'] ?? '',
      nomCategorie: json['nom_categorie'] ?? '',
      createurId:
          json['id_utilisateur'] != null
              ? int.tryParse(json['id_utilisateur'].toString())
              : null,
      typeRessource: json['type_ressource'] ?? '',
      relations:
          (json['relations'] as List<dynamic>?)?.map((relation) {
            return {
              'id':
                  relation['id_type_relation'] != null
                      ? int.parse(relation['id_type_relation'].toString())
                      : 0,
              'nom': relation['nom_relation']?.toString() ?? '',
            };
          }).toList() ??
          [],
      statut: json['statut'] ?? 'en_attente', // Ajouté
    );
  }
}
