<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

$protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
$server_host = $_SERVER['HTTP_HOST'];

$sql = "SELECT * FROM laporan_darurat ORDER BY tanggal_lapor DESC";
$result = $conn->query($sql);

$laporan = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $row['foto_url_full'] = "$protocol://$server_host/emergency_api/uploads/" . $row['foto_path']; 
        $laporan[] = $row;
    }
}

// Pastikan output JSON valid
echo json_encode($laporan);
?>