<?php
// Autorisation de l'origine des requêtes
$allowedOrigins = [
    'http://10.0.2.2', // Ajoutez aussi l'URL HTTP si nécessaire
    'http://192.168.1.10',
    '*',
    'http://localhost:8000',
    'http://localhost:36079',
    'http://79.137.33.245:5000',
    
];

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowedOrigins)) {
    header("Access-Control-Allow-Origin: $origin");
}

// Autorisation des méthodes HTTP
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");

// Autorisation des headers personnalisés
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

// Autorisation des cookies / credentials
header("Access-Control-Allow-Credentials: true");

// Type de contenu par défaut
header("Content-Type: application/json; charset=UTF-8");

// Gestion des requêtes OPTIONS (prévol)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}