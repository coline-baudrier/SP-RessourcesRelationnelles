class User {
  final int id;
  final String email;
  final String nom;
  final String prenom;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      role: json['role'],
    );
  }
}
