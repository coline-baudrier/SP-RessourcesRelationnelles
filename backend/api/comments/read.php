<?php
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../controllers/CommentController.php';
require_once __DIR__ . '/../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new CommentController($db);
    $data = json_decode(file_get_contents('php://input'), true) ?: [];

    $token = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    $result = $controller->read($data, $token);

    http_response_code(isset($result['error']) ? 400 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}