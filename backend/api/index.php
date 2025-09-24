<?php
include("../config/conexion_db.php");
$stmt = $pdo->prepare("
        select * from habit;
    ");

$stmt->execute();
$resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Devolver en JSON
header('Content-Type: application/json');
echo json_encode($resultados, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>