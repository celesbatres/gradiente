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
    // Log de debug
    error_log('POST data received: ' . print_r($_POST, true));
    
    $user = $_POST['user'] ?? null;
    $habit = $_POST['habit'] ?? null;
    $register_type = $_POST['register_type'] ?? null;
    $quantity_register = $_POST['quantity_register'] ?? null;

    error_log("Parsed values - user: $user, habit: $habit, register_type: $register_type, quantity_register: $quantity_register");

    // Validar datos requeridos
    // if (empty($user) || empty($habit) || empty($register_type)) {
    //     throw new Exception('Faltan datos requeridos - user: ' . ($user ?: 'null') . ', habit: ' . ($habit ?: 'null') . ', register_type: ' . ($register_type ?: 'null'));
    // }

    // Insertar en user_habit
    error_log("About to insert into database");
    $stmt = $pdo->prepare("INSERT INTO user_habit (user, habit, register_type, quantity_register, add_date) VALUES (:user, :habit, :register_type, :quantity_register, CURDATE());");
    $stmt->execute(array(
        ':user' => $user,
        ':habit' => $habit,
        ':register_type' => $register_type,
        ':quantity_register' => $quantity_register
    ));

    $user_habit = $pdo->lastInsertId();

    echo json_encode([
        'success' => true,
        'message' => 'User habit created successfully',
        'user_habit' => $user_habit,
    ]);

    

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>