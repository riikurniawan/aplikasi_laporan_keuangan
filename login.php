<?php
include 'conn.php';

$username = $_POST['username'];
$password = $_POST['password'];

$queryResult = $connect->query("SELECT * FROM umkm WHERE username='" . $username . "' and password='" . $password . "'");

if ($queryResult->num_rows > 0) {
    // Jika ada hasil dari query, artinya login berhasil
    $response = array('status' => 'success', 'message' => 'Login berhasil');
} else {
    // Jika tidak ada hasil dari query, artinya login gagal
    $response = array('status' => 'error', 'message' => 'Username atau password salah');
}

echo json_encode($response);
?>
