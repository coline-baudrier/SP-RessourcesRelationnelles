<?php
require_once __DIR__ . '/../vendor/autoload.php';

// Charger les variables d'environnement
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

// Imports JWT
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Router basique
$request = $_SERVER['REQUEST_URI'];
switch ($request) {
    case '/api/login':
        require __DIR__ . '/../api/controllers/UserController.php';
        $controller = new UserController();
        echo json_encode($controller->login());
        break;
    default:
        http_response_code(404);
        echo json_encode(['error' => 'Route non trouvée']);
}