import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/laporan_model.dart';

class EmergencyRemoteDataSource {
  Future<List<LaporanModel>> fetchRiwayat() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/get_history.php'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => LaporanModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future<bool> postLaporan(String kategori, String deskripsi, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/lapor.php'),
    );

    request.fields['kategori'] = kategori;
    request.fields['deskripsi'] = deskripsi;
    
    var pic = await http.MultipartFile.fromPath('image', imagePath);
    request.files.add(pic);

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteLaporan(int id) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/delete_laporan.php'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}