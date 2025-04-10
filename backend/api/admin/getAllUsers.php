<?php
require_once '../../database.php';
require_once '../controllers/UserController.php';
require_once '../cors-header.php';

try {
    $db = Database::getConnection();
    $controller = new UserController($db);

    $headers = getallheaders();
    $token = $headers['Authorization'] ?? null;

    $result = $controller->getAllUsers($token);

    http_response_code(isset($result['error']) ? 403 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    error_log("Erreur serveur: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(["error" => "Erreur serveur interne"]);
}