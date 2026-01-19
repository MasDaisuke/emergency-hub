import '../entities/laporan_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class EmergencyRepository {
  Future<List<LaporanEntity>> getRiwayatLaporan();
  Future<bool> kirimLaporan(String kategori, String deskripsi, XFile imageFile);
  Future<bool> hapusLaporan(int id);
}
