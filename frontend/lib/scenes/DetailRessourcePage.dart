import 'package:flutter/material.dart';
import 'package:frontend/widgets/Header.dart';
import 'package:frontend/widgets/Footer.dart';
import 'package:frontend/services/resource_service.dart';
import 'package:frontend/models/resource.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/services/comment_service.dart';
import 'package:intl/intl.dart';

class RessourceDetailPage extends StatefulWidget {
  final int resourceId;

  const RessourceDetailPage({super.key, required this.resourceId});

  @override
  State<RessourceDetailPage> createState() => _RessourceDetailPageState();
}

class _RessourceDetailPageState extends State<RessourceDetailPage> {
  Future<void> _deleteResource() async {
    try {
      // Récupérez votre token JWT ici (à adapter selon votre système d'authentification)
      final token = 'votre_token_jwt';

      await ResourceService.deleteResource(widget.resourceId, token);

      Navigator.pop(context); // Retour à l'écran précédent après suppression

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ressource supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $e')),
      );
    }
  }

  Future<void> _deleteComment(int commentId) async {
    try {
      final token =
          'votre_token_jwt'; // À remplacer par votre système d'authentification

      // Boîte de dialogue de confirmation
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirmer la suppression'),
              content: const Text(
                'Voulez-vous vraiment supprimer ce commentaire ?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );

      if (confirmed == true) {
        await CommentService.deleteComment(commentId: commentId, token: token);

        setState(() {
          _futureComments = _futureComments.then(
            (comments) => comments.where((c) => c.id != commentId).toList(),
          );
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Commentaire supprimé')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }

  final TextEditingController _commentController = TextEditingController();

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      // Récupérez le token depuis votre système d'authentification
      final token = 'votre_token_jwt'; // À remplacer par votre vrai token

      setState(() {
        _futureComments = CommentService.createComment(
          resourceId: widget.resourceId,
          content: _commentController.text,
          token: token,
        ).then((newComment) async {
          _commentController.clear();
          final comments = await _futureComments;
          return [newComment, ...comments];
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }

  late Future<Resource> _futureResource;
  late Future<List<Comment>> _futureComments;

  @override
  void initState() {
    super.initState();
    _futureResource = ResourceService.fetchResourceById(widget.resourceId);
    _futureComments = CommentService.fetchComments(widget.resourceId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: FutureBuilder<Resource>(
                        future: _futureResource,
                        builder: (context, resourceSnapshot) {
                          if (resourceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (resourceSnapshot.hasError ||
                              !resourceSnapshot.hasData) {
                            return const Center(
                              child: Text('Erreur de chargement'),
                            );
                          }

                          final resource = resourceSnapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      resource.titre,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      _showDeleteDialog(context);
                                    },
                                    color: Colors.grey[600],
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.people_outline,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          resource.nomCategorie,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Publié le ${resource.dateCreation}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                resource.contenu,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  "@${resource.createurPrenom}${resource.createurNom}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildActionButton(
                                      icon: Icons.favorite_border,
                                      label: "J'aime",
                                    ),
                                    _buildActionButton(
                                      icon: Icons.share,
                                      label: "Partager",
                                    ),
                                    _buildActionButton(
                                      icon: Icons.bookmark_border,
                                      label: "Enregistrer",
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(height: 1),

                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FutureBuilder<List<Comment>>(
                                      future: _futureComments,
                                      builder: (context, commentSnapshot) {
                                        final count =
                                            commentSnapshot.hasData
                                                ? commentSnapshot.data!.length
                                                : 0;
                                        return Text(
                                          "Commentaires ($count)",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Supprimer un commentaire",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              FutureBuilder<List<Comment>>(
                                future: _futureComments,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    children:
                                        snapshot.data!
                                            .map(
                                              (comment) => _buildComment(
                                                comment:
                                                    comment, // Passer l'objet Comment directement
                                                showDelete: true,
                                              ),
                                            )
                                            .toList(),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              // Remplacez le TextField existant par ceci :
                              TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: "Écrire un commentaire...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: _submitComment,
                                  ),
                                ),
                                onSubmitted: (_) => _submitComment(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text(
              'Voulez-vous vraiment supprimer cette ressource ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme la boîte de dialogue
                  _deleteResource(); // Effectue la suppression
                },
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: () {}, color: Colors.blue),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.blue)),
      ],
    );
  }

  Widget _buildComment({
    required Comment comment, // Prend désormais un objet Comment directement
    bool showDelete = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.contenu,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${comment.auteurPrenom}${comment.auteurNom}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(comment.dateCreation),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (showDelete)
                TextButton(
                  onPressed: () => _deleteComment(comment.id),
                  child: const Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
