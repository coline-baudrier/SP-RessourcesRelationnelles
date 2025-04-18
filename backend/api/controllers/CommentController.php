<?php
require_once __DIR__ . '/../models/Comment.php';
require_once __DIR__ . '/../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
class CommentController {
    private $model;

    public function __construct($pdo) {
        $this->model = new Comment($pdo);
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
        if (!$auth) return ["error" => "Authentification requise"];

        $required = ['contenu', 'id_ressource'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                return ["error" => "Le champ $field est requis"];
            }
        }

        $data['id_utilisateur'] = $auth->id;
        try {
            $id = $this->model->create($data);
            return ["message" => "Commentaire ajouté", "id" => $id];
        } catch (PDOException $e) {
            return ["error" => "Erreur de création"];
        }
    }

    public function read($data, $token) {
        $auth = $this->checkAuth($token);
        $includePending = $auth && in_array($auth->role, ['moderateur', 'super_admin']);

        if (!empty($data['id'])) {
            $commentaire = $this->model->getById($data['id']);
            return $commentaire ?: ["error" => "Commentaire non trouvé"];
        }

        if (empty($data['id_ressource'])) {
            return ["error" => "ID ressource manquant"];
        }

        return $this->model->getByResource($data['id_ressource'], $includePending);
    }

    public function update($data, $token) {
        $auth = $this->checkAuth($token);
        if (!$auth) return ["error" => "Authentification requise"];

        if (empty($data['id'])) {
            return ["error" => "ID commentaire manquant"];
        }

        // Seul l'auteur ou un modérateur peut modifier
        $commentaire = $this->model->getById($data['id']);
        if (!$commentaire) return ["error" => "Commentaire non trouvé"];

        if ($commentaire['id_utilisateur'] != $auth->id && !in_array($auth->role, ['moderateur', 'super_admin'])) {
            return ["error" => "Action non autorisée"];
        }

        try {
            $success = $this->model->update($data['id'], $data);
            return $success 
                ? ["message" => "Commentaire mis à jour"] 
                : ["error" => "Aucun champ valide à mettre à jour"];
        } catch (PDOException $e) {
            return ["error" => "Erreur de mise à jour"];
        }
    }

    public function delete($data, $token) {
        $auth = $this->checkAuth($token);
        if (!$auth) return ["error" => "Authentification requise"];

        if (empty($data['id'])) {
            return ["error" => "ID commentaire manquant"];
        }

        $commentaire = $this->model->getById($data['id']);
        if (!$commentaire) return ["error" => "Commentaire non trouvé"];

        // Seul l'auteur, un modérateur ou admin peut supprimer
        $canDelete = ($commentaire['id_utilisateur'] == $auth->id) || in_array($auth->role, ['moderateur', 'super_admin']);
        if (!$canDelete) return ["error" => "Action non autorisée"];

        try {
            $this->model->delete($data['id']);
            return ["message" => "Commentaire supprimé"];
        } catch (PDOException $e) {
            return ["error" => "Erreur de suppression"];
        }
    }

    public function moderate($data, $token) {
        $auth = $this->checkAuth($token);
        if (!$auth || !in_array($auth->role, ['moderateur', 'super_admin'])) {
            return ["error" => "Action réservée aux modérateurs"];
        }

        if (empty($data['id']) || empty($data['statut_moderation'])) {
            return ["error" => "Données manquantes"];
        }

        try {
            $this->model->update($data['id'], ['statut_moderation' => $data['statut_moderation']]);
            return ["message" => "Statut de modération mis à jour"];
        } catch (PDOException $e) {
            return ["error" => "Erreur de modération"];
        }
    }
}