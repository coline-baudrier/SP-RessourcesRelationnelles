<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/ResourceController.php';
require_once __DIR__ . '/../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new ResourceController($db);

    $input = file_get_contents("php://input");
    
    if (empty($input)) {
        throw new Exception("Requête vide - données manquantes");
    }

    $data = json_decode($input, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide: " . json_last_error_msg());
    }

    if (!isset($data['id']) || empty($data['id'])) {
        throw new Exception("ID ressource manquant dans le corps de la requête");
    }

    $id = $data['id'];

    if (!is_numeric($id)) {
        throw new Exception("ID ressource doit être un nombre");
    }

    $id = (int)$id; 
    $result = $controller->getResourceById($id);

    http_response_code(isset($result['error']) ? 404 : 200);
    echo json_encode($result, JSON_PRETTY_PRINT);

} catch (Exception $e) {
    error_log("Erreur serveur: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        "error" => $e->getMessage(),
        "timestamp" => time()
    ]);
}