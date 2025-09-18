<?php
include("../config/conexion_db.php");
$user_id = $_POST['user_id'];
$habit_id = $_POST['habit_id'];
$has_reminder = $_POST['has_reminder'];
$stmt = $pdo->prepare("insert into habits_user (user_id, habit_id, has_reminder, reminder, add_date) values (:user_id, :habit_id, :has_reminder, 1, now())");
$stmt->execute(array(':user_id' => $user_id, ':habit_id' => $habit_id, ':has_reminder' => $has_reminder));
$resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($reultados);
?>