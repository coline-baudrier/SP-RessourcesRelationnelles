<?php
require_once '../../database.php';
require_once '../controllers/UserController.php';
require_once '../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new UserController($db);

    $headers = getallheaders();
    $token = $headers['Authorization'] ?? null;
    if (!$token) {
        throw new Exception("Token d'authentification manquant");
    }

    $jsonInput = file_get_contents('php://input');
    if (empty($jsonInput)) {
        throw new Exception("Corps de la requête vide");
    }

    $data = json_decode($jsonInput, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide: " . json_last_error_msg());
    }

    $requiredFields = ['user_id', 'new_role'];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            throw new Exception("Champ requis manquant: " . $field);
        }
    }

    $result = $controller->updateRole($token, $data['user_id'], $data['new_role']);

    $httpCode = isset($result['error']) ? 
        (strpos($result['error'], 'Accès refusé') !== false ? 403 : 400) 
        : 200;
    
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