<?php
require_once '../../database.php';
require_once '../controllers/UserController.php';
require_once '../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new UserController($db);

    $jsonInput = file_get_contents('php://input');
    if (empty($jsonInput)) {
        throw new Exception("Requête vide - données manquantes");
    }

    $data = json_decode($jsonInput, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide: " . json_last_error_msg());
    }

    $requiredFields = ['email', 'new_password'];
    foreach ($requiredFields as $field) {
        if (empty($data[$field])) {
            throw new Exception("Champ requis manquant: " . $field);
        }
    }

    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
        throw new Exception("Format d'email invalide");
    }

    if (strlen($data['new_password']) < 8) {
        throw new Exception("Le mot de passe doit contenir au moins 8 caractères");
    }

    $result = $controller->resetPassword($data['email'], $data['new_password']);

    $httpCode = isset($result['error']) ? 400 : 200;
    http_response_code($httpCode);
    echo json_encode($result);

} catch (Exception $e) {
    error_log("Erreur serveur [" . date('Y-m-d H:i:s') . "]: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        "error" => $e->getMessage(),
        "timestamp" => time()
    ]);
}