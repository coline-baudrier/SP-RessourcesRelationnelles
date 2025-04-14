<?php
class Resource {
    private $pdo;
    private $table = 'Ressource';

    public function __construct($db) {
        $this->pdo = $db;
    }

    public function create($data) {
        try {
            $sql = "INSERT INTO $this->table 
                    (titre, description, contenu, date_creation, id_createur, statut, visibilite, id_type_ressource, id_categorie) 
                    VALUES (:titre, :description, :contenu, NOW(), :id_createur, :statut, :visibilite, :id_type_ressource, :id_categorie)";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                ':titre' => $data['titre'],
                ':description' => $data['description'],
                ':contenu' => $data['contenu'],
                ':id_createur' => $data['id_createur'],
                ':statut' => $data['statut'] ?? 'en_attente',
                ':visibilite' => $data['visibilite'] ?? 'public',
                ':id_type_ressource' => $data['id_type_ressource'],
                ':id_categorie' => $data['id_categorie']
            ]);

            $resourceId = $this->pdo->lastInsertId();

            // Ajout des relations
            if (!empty($data['relations'])) {
                $this->addRelations($resourceId, $data['relations']);
            }

            return [
                "message" => "Ressource créée avec succès",
                "id" => $resourceId
            ];

        } catch (PDOException $e) {
            error_log("Erreur création ressource: " . $e->getMessage());
            return ["error" => "Erreur lors de la création"];
        }
    }

    private function addRelations($resourceId, $relationIds) {
        $sql = "INSERT INTO RessourceTypeRelation (id_ressource, id_type_relation) VALUES ";
        $values = [];
        $params = [];
        
        foreach ($relationIds as $index => $relationId) {
            $values[] = "(:resource_id, :relation_id_$index)";
            $params[":relation_id_$index"] = $relationId;
        }
        
        $sql .= implode(", ", $values);
        $params[':resource_id'] = $resourceId;
        
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute($params);
    }

    public function getAll($filters = []) {
        try {
            $sql = "SELECT r.*, 
                    u.nom as createur_nom, u.prenom as createur_prenom,
                    c.nom_categorie, t.nom_type as type_ressource
                    FROM $this->table r
                    JOIN Utilisateur u ON r.id_createur = u.id_utilisateur
                    JOIN Categorie c ON r.id_categorie = c.id_categorie
                    JOIN TypeRessource t ON r.id_type_ressource = t.id_type_ressource
                    WHERE r.statut = 'publie'";
            
            $params = [];
            
            // Filtres
            if (!empty($filters['categorie'])) {
                $sql .= " AND r.id_categorie = :categorie";
                $params[':categorie'] = $filters['categorie'];
            }
            
            if (!empty($filters['type'])) {
                $sql .= " AND r.id_type_ressource = :type";
                $params[':type'] = $filters['type'];
            }
            
            if (!empty($filters['search'])) {
                $sql .= " AND (r.titre LIKE :search OR r.description LIKE :search)";
                $params[':search'] = '%'.$filters['search'].'%';
            }
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute($params);
            
            $resources = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Récupérer les relations pour chaque ressource
            foreach ($resources as &$resource) {
                $resource['relations'] = $this->getResourceRelations($resource['id_ressource']);
            }
            
            return $resources;
            
        } catch (PDOException $e) {
            error_log("Erreur récupération ressources: " . $e->getMessage());
            return ["error" => "Erreur lors de la récupération"];
        }
    }

    public function getById($id) {
        try {
            $sql = "SELECT r.*, 
                    u.nom as createur_nom, u.prenom as createur_prenom,
                    c.nom_categorie, t.nom_type as type_ressource
                    FROM $this->table r
                    JOIN Utilisateur u ON r.id_createur = u.id_utilisateur
                    JOIN Categorie c ON r.id_categorie = c.id_categorie
                    JOIN TypeRessource t ON r.id_type_ressource = t.id_type_ressource
                    WHERE r.id_ressource = :id";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([':id' => $id]);
            
            $resource = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($resource) {
                $resource['relations'] = $this->getResourceRelations($id);
                $resource['commentaires'] = $this->getComments($id);
            }
            
            return $resource;
            
        } catch (PDOException $e) {
            error_log("Erreur récupération ressource: " . $e->getMessage());
            return null;
        }
    }

    private function getResourceRelations($resourceId) {
        $sql = "SELECT tr.id_type_relation, tr.nom_relation 
                FROM RessourceTypeRelation rtr
                JOIN TypeRelation tr ON rtr.id_type_relation = tr.id_type_relation
                WHERE rtr.id_ressource = :resource_id";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([':resource_id' => $resourceId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    private function getComments($resourceId) {
        $sql = "SELECT c.*, u.nom, u.prenom 
                FROM Commentaire c
                JOIN Utilisateur u ON c.id_utilisateur = u.id_utilisateur
                WHERE c.id_ressource = :resource_id AND c.id_commentaire_parent IS NULL
                AND c.statut_moderation = 'approuve'
                ORDER BY c.date_creation DESC";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([':resource_id' => $resourceId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function update($id, $data) {
        try {
            $allowedFields = ['titre', 'description', 'contenu', 'statut', 'visibilite', 'id_type_ressource', 'id_categorie'];
            $updates = [];
            $params = [':id' => $id];
            
            foreach ($data as $field => $value) {
                if (in_array($field, $allowedFields)) {
                    $updates[] = "$field = :$field";
                    $params[":$field"] = $value;
                }
            }
            
            if (empty($updates)) {
                return ["error" => "Aucun champ valide à mettre à jour"];
            }
            
            $sql = "UPDATE $this->table SET " . implode(", ", $updates) . 
                   ", date_derniere_modification = NOW() WHERE id_ressource = :id";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute($params);
            
            // Mise à jour des relations si fournies
            if (isset($data['relations'])) {
                $this->updateRelations($id, $data['relations']);
            }
            
            return ["message" => "Ressource mise à jour"];
            
        } catch (PDOException $e) {
            error_log("Erreur mise à jour ressource: " . $e->getMessage());
            return ["error" => "Erreur lors de la mise à jour"];
        }
    }

    private function updateRelations($resourceId, $relationIds) {
        // Supprimer les anciennes relations
        $this->pdo->prepare("DELETE FROM RessourceTypeRelation WHERE id_ressource = ?")
                 ->execute([$resourceId]);
        
        // Ajouter les nouvelles
        if (!empty($relationIds)) {
            $this->addRelations($resourceId, $relationIds);
        }
    }

    public function delete($id) {
        try {
            // Supprimer d'abord les dépendances
            $this->pdo->prepare("DELETE FROM RessourceTypeRelation WHERE id_ressource = ?")
                     ->execute([$id]);
            
            $this->pdo->prepare("DELETE FROM Commentaire WHERE id_ressource = ?")
                     ->execute([$id]);
            
            $this->pdo->prepare("DELETE FROM InteractionRessource WHERE id_ressource = ?")
                     ->execute([$id]);
            
            // Puis supprimer la ressource
            $stmt = $this->pdo->prepare("DELETE FROM $this->table WHERE id_ressource = ?");
            $stmt->execute([$id]);
            
            return ["message" => "Ressource supprimée"];
            
        } catch (PDOException $e) {
            error_log("Erreur suppression ressource: " . $e->getMessage());
            return ["error" => "Erreur lors de la suppression"];
        }
    }

    public function getPendingResources() {
        try {
            $sql = "SELECT r.*, u.nom as createur_nom, u.prenom as createur_prenom
                    FROM $this->table r
                    JOIN Utilisateur u ON r.id_createur = u.id_utilisateur
                    WHERE r.statut = 'en_attente'";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch (PDOException $e) {
            error_log("Erreur récupération ressources en attente: " . $e->getMessage());
            return ["error" => "Erreur lors de la récupération"];
        }
    }

    public function updateStatus($id, $status) {
        try {
            $validStatus = ['publie', 'rejete', 'en_attente'];
            if (!in_array($status, $validStatus)) {
                return ["error" => "Statut invalide"];
            }
            
            $sql = "UPDATE $this->table SET statut = :status WHERE id_ressource = :id";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([':status' => $status, ':id' => $id]);
            
            return ["message" => "Statut mis à jour"];
            
        } catch (PDOException $e) {
            error_log("Erreur mise à jour statut: " . $e->getMessage());
            return ["error" => "Erreur lors de la mise à jour"];
        }
    }
}