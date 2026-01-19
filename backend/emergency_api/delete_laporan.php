<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    $id = isset($_POST['id']) ? $_POST['id'] : '';

    if (empty($id)) {
        $response['status'] = false;
        $response['message'] = "ID Laporan tidak ditemukan.";
        echo json_encode($response);
        exit();
    }

    $sql_cek = "SELECT foto_path FROM laporan_darurat WHERE id = '$id'";
    $result = $conn->query($sql_cek);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $foto_path = "uploads/" . $row['foto_path'];

        if (file_exists($foto_path)) {
            unlink($foto_path);
        }
    }

    $sql = "DELETE FROM laporan_darurat WHERE id = '$id'";

    if ($conn->query($sql) === TRUE) {
        $response['status'] = true;
        $response['message'] = "Laporan berhasil dihapus.";
    } else {
        $response['status'] = false;
        $response['message'] = "Gagal menghapus data: " . $conn->error;
    }

} else {
    $response['status'] = false;
    $response['message'] = "Metode request salah (Harus POST).";
}

echo json_encode($response);
?>