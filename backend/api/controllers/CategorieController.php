<?php
require_once __DIR__ . '/../models/Categorie.php';
require_once __DIR__ . '/../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class CategorieController {
    private $model;

    public function __construct($pdo) {
        $this->model = new Categorie($pdo);
    }

    private function checkAuth($token) {
        try {
            if (!$token) {
                return ["error" => "Token manquant"];
            }

            $decoded = JWT::decode($token, new Key($_ENV['JWT_SECRET'], 'HS256'));
            return $decoded;
        } catch (Exception $e) {
            return (object) ["error" => "Token invalide ou expiré"];
        }
    }

    public function create($data, $token) {
        $auth = $this->checkAuth($token);
        if (!in_array($auth->role, ['moderateur', 'super-admin'])) {
            return ["error" => "Action non autorisée"];
        }

        $required = ['nom', 'description'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                return ["error" => "Le champ $field est requis"];
            }
        }

        try {
            $id = $this->model->create($data);
            return ["message" => "Catégorie créée", "id" => $id];
        } catch (PDOException $e) {
            return ["error" => "Erreur de création"];
        }
    }

    public function read($data, $token) {
        $auth = $this->checkAuth($token);
        $includeInactive = in_array($auth->role, ['moderateur', 'super-admin']);

        if (!empty($data['id'])) {
            $categorie = $this->model->getById($data['id']);
            return $categorie ?: ["error" => "Catégorie non trouvée"];
        }

        return $this->model->getAll($includeInactive);
    }

    public function update($data, $token) {
        $auth = $this->checkAuth($token);
        if (!in_array($auth->role, ['moderateur', 'super-admin'])) {
            return ["error" => "Action non autorisée"];
        }

        if (empty($data['id'])) {
            return ["error" => "ID manquant"];
        }

        try {
            $success = $this->model->update($data['id'], $data);
            return $success 
                ? ["message" => "Catégorie mise à jour"] 
                : ["error" => "Aucun champ valide à mettre à jour"];
        } catch (PDOException $e) {
            return ["error" => "Erreur de mise à jour"];
        }
    }

    public function delete($data, $token) {
        $auth = $this->checkAuth($token);
        if ($auth->role !== 'super-admin') {
            return ["error" => "Action réservée aux super-admins"];
        }

        if (empty($data['id'])) {
            return ["error" => "ID manquant"];
        }

        try {
            $this->model->delete($data['id']);
            return ["message" => "Catégorie supprimée"];
        } catch (PDOException $e) {
            return ["error" => "Erreur de suppression"];
        }
    }
}