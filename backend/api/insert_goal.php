<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include("../config/conexion_db.php");

try {
    $user_habit_id = $_POST['user_habit_id'] ?? null;
    $quantity = $_POST['quantity'] ?? null;
    $days = $_POST['days'] ?? null;
    $add_date = $_POST['add_date'] ?? date('Y-m-d');

    // Validar datos requeridos
    if (!$user_habit_id) {
        throw new Exception('user_habit_id es requerido');
    }

    // Insertar en goal
    $stmt = $pdo->prepare("INSERT INTO goal (user_habit, quantity, days, actual, add_date) VALUES (:user_habit_id, :quantity, :days, 1, :add_date)");
    $stmt->execute(array(
        ':user_habit_id' => $user_habit_id,
        ':quantity' => $quantity,
        ':days' => $days,
        ':add_date' => $add_date
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
