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

    $user = isset($_POST['user']) ? $_POST['user'] : '';
    $date = isset($_POST['date']) ? $_POST['date'] : '';
    $day = isset($_POST['day']) ? $_POST['day'] : '';

    $stmt = $pdo->prepare("
            select * from habit h join user_habit uh on uh.habit = h.habit join goal g on g.user_habit = uh.user_habit where uh.user=:user and(g.repeat_h = 'daily' || (g.repeat_h = 'weekly' and find_in_set(:day, days)>0) || (g.repeat_h = 'once' && g.date_h = :date));
        ");

    $stmt->execute([':user' => $user, ':date' => $date, ':day' => $day]);
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