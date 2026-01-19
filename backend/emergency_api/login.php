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
    $email = $_POST['email'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM users WHERE email = '$email'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if (password_verify($password, $row['password'])) {
            $response['status'] = true;
            $response['message'] = "Login Berhasil";
            $response['data'] = array(
                'id' => $row['id'],
                'name' => $row['name'],
                'email' => $row['email']
            );
        } else {
            $response['status'] = false;
            $response['message'] = "Password salah!";
        }
    } else {
        $response['status'] = false;
        $response['message'] = "Email tidak ditemukan!";
    }
}

echo json_encode($response);
?>