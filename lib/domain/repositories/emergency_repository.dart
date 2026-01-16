import '../entities/laporan_entity.dart';

abstract class EmergencyRepository {
  Future<List<LaporanEntity>> getRiwayatLaporan();
  Future<bool> kirimLaporan(
    String kategori,
    String deskripsi,
    String imagePath,
  );
  Future<bool> hapusLaporan(int id);
}
