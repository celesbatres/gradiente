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
    $user_id = isset($_POST['user']) ? $_POST['user'] : '';
    $stmt = $pdo->prepare("
            select h.name, h.habit_type from user_habit hu join habit h on h.habit=hu.habit where hu.user = :user;
        ");

    $stmt->execute([':user' => $user_id]);
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