// import '../repositories/emergency_repository.dart';

class HapusLaporanUseCase {
  final EmergencyRepository repository;
  HapusLaporanUseCase(this.repository);

  Future<bool> execute(int id) {
    return repository.hapusLaporan(id);
  }
}