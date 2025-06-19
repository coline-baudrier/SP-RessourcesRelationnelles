<?php
require_once __DIR__ . '/../models/Resource.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class ResourceController {
    private $resourceModel;
    private $userModel;

    public function __construct($db) {
        $this->resourceModel = new Resource($db);
        $this->userModel = new User($db);
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

    // POST /api/resources
    public function createResource($data, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        $required = ['titre', 'description', 'contenu', 'id_type_ressource', 'id_categorie'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                return ["error" => "Le champ $field est requis"];
            }
        }

        $data['id_createur'] = $auth->sub;
        return $this->resourceModel->create($data);
    }

    // GET /api/resources
    public function getAllResources($filters = []) {
        return $this->resourceModel->getAll($filters);
    }

    // GET /api/resources/{id}
    public function getResourceById($id) {
        $resource = $this->resourceModel->getById($id);
        return $resource ?: ["error" => "Ressource non trouvée"];
    }

    // PUT /api/resources/{id}
    public function updateResource($id, $data, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        $resource = $this->resourceModel->getById($id);
        if (!$resource) {
            return ["error" => "Ressource non trouvée"];
        }

        // Seul l'auteur ou un admin peut modifier
        if ($resource['id_createur'] != $auth->sub && !in_array($auth->role, ['super_admin', 'moderateur'])) {
            return ["error" => "Action non autorisée"];
        }

        return $this->resourceModel->update($id, $data);
    }

    // DELETE /api/resources/{id}
    public function deleteResource($id, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        $resource = $this->resourceModel->getById($id);
        if (!$resource) {
            return ["error" => "Ressource non trouvée"];
        }

        // Seul l'auteur ou un admin peut supprimer
        if ($resource['id_createur'] != $auth->sub && !in_array($auth->role, ['super_admin', 'moderateur'])) {
            return ["error" => "Action non autorisée"];
        }

        return $this->resourceModel->delete($id);
    }

    // GET /api/admin/resources/pending
    public function getPendingResources($token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if (!in_array($auth->role, ['super_admin', 'moderateur'])) {
            return ["error" => "Accès refusé"];
        }

        return $this->resourceModel->getPendingResources();
    }

    // PUT /api/admin/resources/{id}/status
    public function updateResourceStatus($id, $status, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if (!in_array($auth->role, ['super_admin', 'moderateur'])) {
            return ["error" => "Accès refusé"];
        }

        return $this->resourceModel->updateStatus($id, $status);
    }

    // POST /api/resources/{id}/favorite
    public function toggleFavorite($id, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        // Implémentation de la logique favori
        return ["message" => "Favori mis à jour"];
    }

    // POST /api/resources/{id}/status
    public function updateUserResourceStatus($id, $status, $token) {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        // Implémentation du statut utilisateur
        return ["message" => "Statut utilisateur mis à jour"];
    }
}