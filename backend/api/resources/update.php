<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/ResourceController.php';
require_once __DIR__ . '/../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new ResourceController($db);

    $headers = getallheaders();
    $token = $headers['Authorization'] ?? null;

    $data = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide");
    }

    // Vérifie la présence de l'ID dans le JSON
    if (!isset($data['id_ressource'])) {
        throw new Exception("ID ressource manquant dans le corps de la requête");
    }

    $id = $data['id_ressource'];
    unset($data['id_ressource']); // On retire l'ID du tableau de données à mettre à jour

    $result = $controller->updateResource($id, $data, $token);

    http_response_code(isset($result['error']) ? 400 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}