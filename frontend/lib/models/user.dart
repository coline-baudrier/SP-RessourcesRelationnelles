class User {
  final int id;
  final String email;
  final String nom;
  final String prenom;
  final String role;
  final bool compteActif;

  User({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.compteActif,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_utilisateur'] ?? json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      role: json['role'],
      compteActif: json['compte_actif'] == 1 || json['compte_actif'] == true,
    );
  }
}
