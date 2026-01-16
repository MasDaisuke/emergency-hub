import '../../domain/entities/laporan_entity.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/emergency_remote_datasource.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource remoteDataSource;

  EmergencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LaporanEntity>> getRiwayatLaporan() async {
    return await remoteDataSource.fetchRiwayat();
  }

  @override
  Future<bool> kirimLaporan(String kategori, String deskripsi, String imagePath) async {
    return await remoteDataSource.postLaporan(kategori, deskripsi, imagePath);
  }

  @override
  Future<bool> hapusLaporan(int id) async {
    return await remoteDataSource.deleteLaporan(id);
  }
}