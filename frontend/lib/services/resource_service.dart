import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/resource.dart';

class ResourceService {
  static const String _baseUrl = 'http://localhost:8000/resources';

  static Future<List<Resource>> fetchResources() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/getAll.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Resource.fromJson(json)).toList();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec du chargement: ${e.toString()}');
    }
  }

  static Future<Resource> fetchResourceById(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/getOne.php'),
        body: json.encode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Resource.fromJson(data);
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec du chargement: ${e.toString()}');
    }
  }

  static Future<void> deleteResource(int id, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/delete.php'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de la suppression: ${e.toString()}');
    }
  }

  static Future<Resource> createResource({
    required String titre,
    required String contenu,
    required String token,
    required int idTypeRelation,
    required int idCategorie,
    required int idTypeRessource,
    required String statut,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/resources/create.php'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: json.encode({
          'titre': titre,
          'description': description,
          'contenu': contenu,
          'id_type_ressource': idTypeRelation,
          'id_categorie': idCategorie,
          'statut': statut,
        }),
      );

      if (response.statusCode == 201) {
        return Resource.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de la création: ${e.toString()}');
    }
  }

  static Future<List<Resource>> getPendingResources(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admin/pending.php'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load pending resources: ${response.statusCode}',
      );
    }
  }

  static Future<void> approveResource(int resourceId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/update_status.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'id': resourceId,
        'status': 'publie', // ou le statut que vous utilisez pour "publié"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve resource: ${response.body}');
    }
  }

  static Future<void> rejectResource(int resourceId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/update_status.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'id': resourceId,
        'status': 'rejete', // ou le statut que vous utilisez pour "rejeté"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject resource: ${response.body}');
    }
  }
}
