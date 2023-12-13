<?php


include 'conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

// Menggunakan prepared statement untuk mencegah SQL injection
$stmt = $connect->prepare("SELECT * FROM penghasilan");
$stmt->execute();

$result = $stmt->get_result();
$data = array();

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);


// include 'conn.php';
// header("Access-Control-Allow-Origin: *");
// header("Access-Control-Allow-Headers: *");

// $username = $_GET['username'];

// // Menggunakan prepared statement untuk mencegah SQL injection
// $stmt = $connect->prepare("SELECT umkm.*, penghasilan.total_penghasilan 
//                           FROM umkm 
//                           LEFT JOIN penghasilan ON umkm.id_umkm = penghasilan.id_umkm 
//                           WHERE umkm.username = ?");
// $stmt->bind_param("s", $username);
// $stmt->execute();

// $result = $stmt->get_result();
// $data = array();

// while ($row = $result->fetch_assoc()) {
//     $data[] = $row;
// }

// echo json_encode($data);
?>
