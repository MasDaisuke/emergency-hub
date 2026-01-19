<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Cek apakah email sudah terdaftar
    $cek = "SELECT * FROM users WHERE email = '$email'";
    $result = $conn->query($cek);

    if ($result->num_rows > 0) {
        $response['status'] = false;
        $response['message'] = "Email sudah terdaftar!";
    } else {
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        
        $sql = "INSERT INTO users (name, email, password) VALUES ('$name', '$email', '$hashed_password')";
        if ($conn->query($sql) === TRUE) {
            $response['status'] = true;
            $response['message'] = "Registrasi Berhasil! Silakan Login.";
        } else {
            $response['status'] = false;
            $response['message'] = "Gagal Register: " . $conn->error;
        }
    }
}

echo json_encode($response);
?>