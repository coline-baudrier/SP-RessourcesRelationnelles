<?php
require_once '../../database.php';
require_once '../controllers/UserController.php';
require_once '../cors-header.php';

try {
    $db = Database::getConnection();
    $controller = new UserController($db);

    $headers = getallheaders();
    $token = $headers['Authorization'] ?? null;

    $data = json_decode(file_get_contents("php://input"), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Format JSON invalide");
    }

    if (empty($data['user_id']) || empty($data['new_role'])) {
        throw new Exception("Données manquantes");
    }

    $result = $controller->updateRole($token, $data['user_id'], $data['new_role']);

    http_response_code(isset($result['error']) ? 403 : 200);
    echo json_encode($result);

} catch (Exception $e) {
    error_log("Erreur serveur: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}