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

    $response = file_get_contents('php://input');
    $data = json_decode($response, true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide: " . json_last_error_msg());
    }

    $result = $controller->createResource($data, $token);

    http_response_code(isset($result['error']) ? 400 : 201);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}
