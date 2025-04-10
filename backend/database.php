<?php

require_once __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '');
$dotenv->load();

class Database
{
    private static $instances = [];

    public static function getConnection($dbName = null)
    {
        if (!$dbName) {
            $dbName = $_ENV['DB_NAME'];
        }

        if (!isset(self::$instances[$dbName])) {
            try {
                $pdo = new PDO("mysql:host={$_ENV['DB_HOST']};dbname=$dbName;charset=utf8", $_ENV['DB_USER'], $_ENV['DB_PASS']);
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                self::$instances[$dbName] = $pdo;
            } catch (PDOException $e) {
                die("Erreur de connexion : " . $e->getMessage());
            }
        }

        return self::$instances[$dbName];
    }
}