<?php
// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, ngrok-skip-browser-warning');
    header('Access-Control-Max-Age: 86400');
    http_response_code(200);
    exit();
}

// Set CORS headers for actual request
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, ngrok-skip-browser-warning');
ob_clean();
header("Content-Type: application/json; charset=UTF-8");

try {
    include("../config/conexion_db.php");
    $firebase_uid = $_POST['firebase_uid'];
    $stmt = $pdo->prepare("
            select user from user where firebase_uid = :firebase_uid;
        ");
    $stmt->execute(array(':firebase_uid' => $firebase_uid));
    $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    // Return JSON response
    echo json_encode([
        'success' => true,
        'data' => $resultados,
        'count' => count($resultados)
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    exit;
} catch (Exception $e) {
    // Return error in JSON format
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'data' => []
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    exit;
}
?>