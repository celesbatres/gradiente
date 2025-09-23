<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include("../config/conexion_db.php");

try {
    $user_id = $_POST['user_id'] ?? null;
    $habit_id = $_POST['habit_id'] ?? null;
    $register_type_id = $_POST['register_type_id'] ?? null;
    $quantity_register = $_POST['quantity_register'] ?? null;

    // Validar datos requeridos
    if (!$user_id || !$habit_id || !$register_type_id) {
        throw new Exception('Faltan datos requeridos');
    }

    // Insertar en user_habit
    $stmt = $pdo->prepare("INSERT INTO user_habit (user, habit, register_type, quantity_register, add_date) VALUES (:user_id, :habit_id, :register_type_id, :quantity_register, CURDATE())");
    $stmt->execute(array(
        ':user_id' => $user_id,
        ':habit_id' => $habit_id,
        ':register_type_id' => $register_type_id,
        ':quantity_register' => $quantity_register
    ));

    $user_habit_id = $pdo->lastInsertId();

    echo json_encode([
        'success' => true,
        'message' => 'User habit created successfully',
        'user_habit_id' => $user_habit_id
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>