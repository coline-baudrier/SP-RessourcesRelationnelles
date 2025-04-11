<?php
require_once '../models/User.php';
require_once '../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class UserController
{
    private $userModel;

    public function __construct($db)
    {
        $this->userModel = new User($db);
    }

    private function checkAuth($token)
    {
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

    public function login($email, $password)
    {
        $result = $this->userModel->authenticate($email, $password);
        
        if (isset($result['error'])) {
            return $result;
        }

        // Génération du JWT
        $payload = [
            'sub' => $result['id_utilisateur'],
            'email' => $result['email'],
            'role' => $result['role'],
            'iat' => time(),
            'exp' => time() + (600 * 600) // 1 heure d'expiration
        ];

        $jwt = JWT::encode($payload, $_ENV['JWT_SECRET'], 'HS256');

        return [
            'token' => $jwt,
            'user' => [
                'id' => $result['id_utilisateur'],
                'email' => $result['email'],
                'nom' => $result['nom'],
                'prenom' => $result['prenom'],
                'role' => $result['role']
            ]
        ];
    }

    // Récupérer le profil utilisateur
    public function getProfile($token)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        $userId = $auth->sub;
        $user = $this->userModel->getUserById($userId);
        
        if (!$user) {
            return ["error" => "Utilisateur non trouvé"];
        }

        return ["profile" => $user];
    }

    // Supprimer un utilisateur (admin seulement)
    public function deleteUser($token, $userId)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if ($auth->role !== 'super_admin') {
            return ["error" => "Accès refusé: rôle insuffisant"];
        }

        $result = $this->userModel->deleteUser($userId);
        if (isset($result['error'])) {
            return $result;
        }

        return ["message" => "Utilisateur supprimé avec succès"];
    }

    // Mettre à jour le profil utilisateur
    public function updateUser($token, $data)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        $userId = $auth->sub;
        return $this->userModel->updateUser($userId, $data);
    }

    // Changer le statut actif/inactif (admin seulement)
    public function toggleUserStatus($token, $userId)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if (!in_array($auth->role, ['moderateur', 'super_admin'])) {
            return ["error" => "Accès refusé: rôle insuffisant"];
        }

        return $this->userModel->toggleUserStatus($userId);
    }

    // Lister tous les utilisateurs (admin seulement)
    public function getAllUsers($token) 
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if (!in_array($auth->role, ['moderateur', 'super_admin'])) {
            return ["error" => "Accès refusé: rôle insuffisant"];
        }

        return $this->userModel->getAllUsers();
    }

    // Réinitialiser le mot de passe
    public function resetPassword($email, $newPassword)
    {
        return $this->userModel->resetPassword($email, $newPassword);
    }

    // Créer un administrateur (super_admin seulement)
    public function createAdmin($token, $data)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if ($auth->role !== 'super_admin') {
            return ["error" => "Accès refusé: rôle insuffisant"];
        }

        $required = ['email', 'password', 'nom', 'prenom'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                return ["error" => "Le champ $field est requis"];
            }
        }

        return $this->userModel->createUser(
            $data['email'],
            $data['password'],
            $data['nom'],
            $data['prenom'],
            'super_admin' // Rôle forcé pour les admins créés ainsi
        );
    }

    // Mettre à jour le rôle d'un utilisateur (super_admin seulement)
    public function updateRole($token, $userId, $newRole)
    {
        $auth = $this->checkAuth($token);
        if (isset($auth->error)) {
            return ["error" => $auth->error];
        }

        if ($auth->role !== 'super_admin') {
            return ["error" => "Accès refusé: rôle insuffisant"];
        }

        return $this->userModel->updateRole($userId, $newRole);
    }

    // Création d'un compte citoyen
    public function registerCitizen($data)
    {
        $required = ['email', 'password', 'nom', 'prenom'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                return ["error" => "Le champ $field est requis"];
            }
        }

        // Validation supplémentaire si nécessaire
        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            return ["error" => "Email invalide"];
        }

        if (strlen($data['password']) < 8) {
            return ["error" => "Le mot de passe doit faire au moins 8 caractères"];
        }

        return $this->userModel->createCitizenAccount(
            $data['email'],
            $data['password'],
            $data['nom'],
            $data['prenom']
        );
    }
}