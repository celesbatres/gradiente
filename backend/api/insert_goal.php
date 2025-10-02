<?php
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

include("../config/conexion_db.php");

try {
    $user_habit = $_POST['user_habit'] ?? null;
    $quantity = $_POST['quantity'] ?? null;
    $days = $_POST['days'] ?? null;

    // Validar datos requeridos
    if (!$user_habit) {
        throw new Exception('user_habit es requerido');
    }

    // Insertar en goal
    $stmt = $pdo->prepare("INSERT INTO goal (user_habit, quantity, days, actual, add_date) VALUES (:user_habit, :quantity, :days, 1, CURDATE());");
    $stmt->execute(array(
        ':user_habit' => $user_habit,
        ':quantity' => $quantity,
        ':days' => $days,
    ));

    $goal_id = $pdo->lastInsertId();

    echo json_encode([
        'success' => true,
        'message' => 'Goal created successfully',
        'goal_id' => $goal_id
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
