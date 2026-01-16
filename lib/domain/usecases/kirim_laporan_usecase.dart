import '../repositories/emergency_repository.dart';

class KirimLaporanUseCase {
  final EmergencyRepository repository;
  KirimLaporanUseCase(this.repository);

  Future<bool> execute(String kategori, String deskripsi, String imagePath) {
    return repository.kirimLaporan(kategori, deskripsi, imagePath);
  }
}