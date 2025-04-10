<?php
require_once '../../database.php';
require_once '../controllers/UserController.php';
require_once '../cors-header.php';

header('Content-Type: application/json');

try {
    $db = Database::getConnection();
    $controller = new UserController($db);

    $data = json_decode(file_get_contents("php://input"), true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["error" => "Format JSON invalide"]);
        exit();
    }

    $result = $controller->registerCitizen($data);

    if (isset($result['error'])) {
        http_response_code(400);
    } else {
        http_response_code(201); // Created
    }
    
    echo json_encode($result);

} catch (Exception $e) {
    error_log("Erreur d'inscription: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(["error" => "Erreur serveur lors de l'inscription"]);
}