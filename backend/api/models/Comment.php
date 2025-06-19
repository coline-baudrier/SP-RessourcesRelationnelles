<?php
class Comment {
    private $pdo;
    private $table = 'Commentaire';

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function create($data) {
        $sql = "INSERT INTO $this->table 
                (contenu, date_creation, id_utilisateur, id_ressource, id_commentaire_parent, statut_moderation) 
                VALUES (:contenu, NOW(), :id_utilisateur, :id_ressource, :id_parent, :statut)";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':contenu' => $data['contenu'],
            ':id_utilisateur' => $data['id_utilisateur'],
            ':id_ressource' => $data['id_ressource'],
            ':id_parent' => $data['id_commentaire_parent'] ?? null,
            ':statut' => $data['statut_moderation'] ?? 'en_attente'
        ]);

        return $this->pdo->lastInsertId();
    }

    public function getById($id) {
        $sql = "SELECT c.*, u.nom, u.prenom 
                FROM $this->table c
                JOIN Utilisateur u ON c.id_utilisateur = u.id_utilisateur
                WHERE c.id_commentaire = ?";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getByResource($resourceId, $includePending = false) {
        $sql = "SELECT c.*, u.nom, u.prenom 
                FROM $this->table c
                JOIN Utilisateur u ON c.id_utilisateur = u.id_utilisateur
                WHERE c.id_ressource = ?";
        
        if (!$includePending) {
            $sql .= " AND c.statut_moderation = 'approuve'";
        }

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([$resourceId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function update($id, $data) {
        $allowedFields = ['contenu', 'statut_moderation'];
        $updates = [];
        $params = [':id' => $id];

        foreach ($data as $field => $value) {
            if (in_array($field, $allowedFields)) {
                $updates[] = "$field = :$field";
                $params[":$field"] = $value;
            }
        }

        if (empty($updates)) return false;

        $sql = "UPDATE $this->table SET " . implode(', ', $updates) . " WHERE id_commentaire = :id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute($params);
    }

    public function delete($id) {
        $sql = "DELETE FROM $this->table WHERE id_commentaire = ?";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([$id]);
    }
}