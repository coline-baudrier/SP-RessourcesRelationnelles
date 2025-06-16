import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'http://79.137.33.245:9000/auth';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur de connexion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de la connexion: ${e.toString()}');
    }
  }

  static Future<User> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/getProfile.php'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Erreur lors du chargement du profil');
    }
  }

  static Future<void> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/resetPassword.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'new_password': newPassword}),
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(
        data['error'] ?? 'Erreur lors du changement de mot de passe',
      );
    }
  }
}
