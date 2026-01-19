import '../repositories/emergency_repository.dart';
import 'package:image_picker/image_picker.dart';

class KirimLaporanUseCase {
  final EmergencyRepository repository;
  KirimLaporanUseCase(this.repository);

  Future<bool> execute(String kategori, String deskripsi, XFile imageFile) {
    return repository.kirimLaporan(kategori, deskripsi, imageFile);
  }
}