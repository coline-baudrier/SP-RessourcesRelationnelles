<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/ResourceController.php';
require_once __DIR__ . '/../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new ResourceController($db);

    $filters = [
        'categorie' => $_GET['categorie'] ?? null,
        'type' => $_GET['type'] ?? null,
        'search' => $_GET['search'] ?? null
    ];

    $result = $controller->getAllResources($filters);

    http_response_code(isset($result['error']) ? 400 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}