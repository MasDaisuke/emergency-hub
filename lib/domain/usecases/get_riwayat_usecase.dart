// import '../entities/laporan_entity.dart';
// import '../repositories/emergency_repository.dart';

class GetRiwayatUseCase {
  final EmergencyRepository repository;
  GetRiwayatUseCase(this.repository);

  Future<List<LaporanEntity>> execute() {
    return repository.getRiwayatLaporan();
  }
}