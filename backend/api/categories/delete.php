<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../../controllers/CategorieController.php';
require_once __DIR__ . '/../../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new CategorieController($db);
    $data = json_decode(file_get_contents('php://input'), true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide");
    }

    $token = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    $result = $controller->delete($data, $token);

    http_response_code(isset($result['error']) ? (strpos($result['error'], 'ID') !== false ? 400 : 403) : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}