import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8000/auth';

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
}
