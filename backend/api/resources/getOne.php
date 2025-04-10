<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/ResourceController.php';
require_once __DIR__ . '/../cors_header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new ResourceController($db);

    $id = $_GET['id'] ?? null;
    if (!$id) {
        throw new Exception("ID ressource manquant");
    }

    $result = $controller->getResourceById($id);

    http_response_code(isset($result['error']) ? 404 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}