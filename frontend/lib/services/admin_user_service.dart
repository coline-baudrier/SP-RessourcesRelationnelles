import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user.dart';

class AdminUserService {
  static final String _baseUrl = 'http://localhost:8000';

  static Future<List<User>> getAllUsers(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admin/getAllUsers.php'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  static Future<bool> toggleUserStatus(String token, int userId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/toggleStatus.php'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to toggle user status: ${response.statusCode}');
    }
  }

  static Future<bool> updateUserRole(
    String token,
    int userId,
    String newRole,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/updateRole.php'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'new_role': newRole}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user role: ${response.statusCode}');
    }
  }

  static Future<bool> createUser(
    String token,
    String email,
    String password,
    String nom,
    String prenom,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/createAdmin.php'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'nom': nom,
        'prenom': prenom,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }
}
