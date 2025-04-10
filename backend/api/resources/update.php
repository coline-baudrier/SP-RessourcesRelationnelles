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

    $id = $_GET['id'] ?? null;
    if (!$id) {
        throw new Exception("ID ressource manquant");
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide");
    }

    $result = $controller->updateResource($id, $data, $token);

    http_response_code(isset($result['error']) ? 400 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}