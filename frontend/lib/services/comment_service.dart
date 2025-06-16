import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/comment.dart';

class CommentService {
  static const String _baseUrl = 'http://79.137.33.245:9000/comments';

  static Future<List<Comment>> fetchComments(int resourceId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/read.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id_ressource': resourceId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  static Future<Comment> createComment({
    required int resourceId,
    required String content,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create.php'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: json.encode({'id_ressource': resourceId, 'contenu': content}),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  static Future<void> deleteComment({
    required int commentId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/delete.php'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: json.encode({'id': commentId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de la suppression: ${e.toString()}');
    }
  }
}
