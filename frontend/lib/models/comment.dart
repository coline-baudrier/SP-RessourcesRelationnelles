class Comment {
  final int id;
  final String contenu;
  final DateTime dateCreation;
  final String auteurNom;
  final String auteurPrenom;
  final int? auteurId;

  Comment({
    required this.id,
    required this.contenu,
    required this.dateCreation,
    required this.auteurNom,
    required this.auteurPrenom,
    this.auteurId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: int.parse(json['id_commentaire'].toString()),
      contenu: json['contenu'] ?? '',
      dateCreation: DateTime.parse(json['date_creation'].toString()),
      auteurNom: json['nom'] ?? 'Anonyme',
      auteurPrenom: json['prenom'] ?? '',
      auteurId:
          json['id_utilisateur'] != null
              ? int.tryParse(json['id_utilisateur'].toString())
              : null,
    );
  }
}
