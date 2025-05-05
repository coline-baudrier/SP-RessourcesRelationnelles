import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/resource.dart';

class AdminResourceService {
  static const String _baseUrl = 'http://localhost:8000/resources/admin';

  static Future<List<Resource>> getPendingResources(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pending.php'),
      headers: {'Authorization': token},
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
      Uri.parse('$_baseUrl/update_status.php'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
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
      Uri.parse('$_baseUrl/update_status.php'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
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
