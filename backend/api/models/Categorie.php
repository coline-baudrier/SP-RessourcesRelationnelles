<?php
class Categorie {
    private $pdo;
    private $table = 'Categorie';

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function create($data) {
        $sql = "INSERT INTO $this->table 
                (nom_categorie, description, date_creation, actif) 
                VALUES (:nom, :description, NOW(), :actif)";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':nom' => $data['nom'],
            ':description' => $data['description'],
            ':actif' => $data['actif'] ?? true
        ]);
        return $this->pdo->lastInsertId();
    }

    public function getById($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM $this->table WHERE id_categorie = ?");
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getAll($includeInactive = false) {
        $sql = "SELECT * FROM $this->table";
        if (!$includeInactive) $sql .= " WHERE actif = TRUE";
        $stmt = $this->pdo->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function update($id, $data) {
        $allowedFields = ['nom_categorie', 'description', 'actif'];
        $updates = [];
        $params = [':id' => $id];

        foreach ($data as $field => $value) {
            if (in_array($field, $allowedFields)) {
                $updates[] = "$field = :$field";
                $params[":$field"] = $value;
            }
        }

        if (empty($updates)) return false;

        $sql = "UPDATE $this->table SET " . implode(', ', $updates) . " WHERE id_categorie = :id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute($params);
    }

    public function delete($id) {
        $sql = "UPDATE $this->table SET actif = FALSE WHERE id_categorie = ?";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([$id]);
    }
}