// models/comment.dart
class Comment {
  final int id;
  final String contenu;
  final DateTime dateCreation;
  final String auteurNom;
  final String auteurPrenom;

  Comment({
    required this.id,
    required this.contenu,
    required this.dateCreation,
    required this.auteurNom,
    required this.auteurPrenom,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id_commentaire'],
      contenu: json['contenu'],
      dateCreation: DateTime.parse(json['date_creation']),
      auteurNom: json['nom'],
      auteurPrenom: json['prenom'],
    );
  }
}
