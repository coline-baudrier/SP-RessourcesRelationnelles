<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/CommentController.php';
require_once __DIR__ . '/../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new CommentController($db);
    $data = json_decode(file_get_contents('php://input'), true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide");
    }

    $token = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    $result = $controller->moderate($data, $token);

    http_response_code(isset($result['error']) ? 403 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}