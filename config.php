<?php
declare(strict_types=1);
define('APP_ENV', 'development'); // Change to production before public hosting.
define('BASE_URL', '/KigoTech_online_market');
define('DB_HOST', 'localhost');
define('DB_NAME', 'kigotech_market');
define('DB_USER', 'root');
define('DB_PASS', ''); // Set your MySQL password here.
if (session_status() === PHP_SESSION_NONE) { session_start(); }
function db(): PDO {
 static $pdo = null;
 if (!$pdo) {
  $pdo = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4', DB_USER, DB_PASS, [
   PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC
  ]);
 }
 return $pdo;
}
function json_out(array $data, int $status=200): never {
 http_response_code($status); header('Content-Type: application/json'); echo json_encode($data); exit;
}
function current_user(): ?array {
 if (empty($_SESSION['user_id'])) return null;
 $s=db()->prepare('SELECT id,full_name,phone,email FROM users WHERE id=?'); $s->execute([$_SESSION['user_id']]); return $s->fetch() ?: null;
}
function require_user(): array { $u=current_user(); if(!$u) json_out(['ok'=>false,'message'=>'Please sign in first.'],401); return $u; }
function require_admin(): void { if(empty($_SESSION['admin_id'])) { header('Location: login.php'); exit; } }
