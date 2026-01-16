import 'package:flutter/material.dart';
import '../../domain/entities/laporan_entity.dart';
import '../../domain/usecases/get_riwayat_usecase.dart';
import '../../domain/usecases/kirim_laporan_usecase.dart';
import '../../domain/usecases/hapus_laporan_usecase.dart';

class EmergencyProvider extends ChangeNotifier {
  final GetRiwayatUseCase getRiwayatUseCase;
  final KirimLaporanUseCase kirimLaporanUseCase;
  final HapusLaporanUseCase hapusLaporanUseCase;

  EmergencyProvider({
    required this.getRiwayatUseCase,
    required this.kirimLaporanUseCase,
    required this.hapusLaporanUseCase,
  });

  List<LaporanEntity> _laporanList = [];
  bool _isLoading = false;

  List<LaporanEntity> get laporanList => _laporanList;
  bool get isLoading => _isLoading;

  Future<void> fetchRiwayat() async {
    _isLoading = true;
    notifyListeners();
    try {
      _laporanList = await getRiwayatUseCase.execute();
    } catch (e) {
      print("Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> kirimLaporan(
    String kategori,
    String deskripsi,
    String imagePath,
  ) async {
    _isLoading = true;
    notifyListeners();
    bool success = await kirimLaporanUseCase.execute(
      kategori,
      deskripsi,
      imagePath,
    );
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> hapusLaporan(int id) async {
    bool success = await hapusLaporanUseCase.execute(id);
    if (success) {
      fetchRiwayat();
    }
  }
}
