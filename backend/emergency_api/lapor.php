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
    
    $kategori = isset($_POST['kategori']) ? $_POST['kategori'] : '';
    $deskripsi = isset($_POST['deskripsi']) ? $_POST['deskripsi'] : '';

    if (empty($kategori) || empty($deskripsi)) {
        $response['status'] = false;
        $response['message'] = "Kategori dan Deskripsi tidak boleh kosong.";
        echo json_encode($response);
        exit();
    }

    if (isset($_FILES['image']['name'])) {
        $target_dir = "uploads/";
        
        // Buat folder jika belum ada
        if (!file_exists($target_dir)) {
            mkdir($target_dir, 0777, true);
        }

        $image_name = time() . "_" . basename($_FILES["image"]["name"]);
        $target_file = $target_dir . $image_name;

        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
            $sql = "INSERT INTO laporan_darurat (kategori, deskripsi, foto_path) VALUES ('$kategori', '$deskripsi', '$image_name')";
            
            if ($conn->query($sql) === TRUE) {
                $response['status'] = true;
                $response['message'] = "Laporan berhasil dikirim!";
            } else {
                $response['status'] = false;
                $response['message'] = "Database Error: " . $conn->error;
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Gagal upload gambar ke server.";
        }
    } else {
        $response['status'] = false;
        $response['message'] = "Foto wajib disertakan.";
    }
} else {
    $response['status'] = false;
    $response['message'] = "Invalid Request Method.";
}

echo json_encode($response);
?>