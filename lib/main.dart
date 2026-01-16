import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/emergency_remote_datasource.dart';
import 'data/repositories/emergency_repository_impl.dart';
import 'domain/usecases/get_riwayat_usecase.dart';
import 'domain/usecases/kirim_laporan_usecase.dart';
import 'domain/usecases/hapus_laporan_usecase.dart';
import 'presentation/providers/emergency_provider.dart';
import 'presentation/pages/dashboard_page.dart';

void main() {
  final dataSource = EmergencyRemoteDataSource();
  final repository = EmergencyRepositoryImpl(remoteDataSource: dataSource);
  final getRiwayat = GetRiwayatUseCase(repository);
  final kirimLaporan = KirimLaporanUseCase(repository);
  final hapusLaporan = HapusLaporanUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmergencyProvider(
            getRiwayatUseCase: getRiwayat,
            kirimLaporanUseCase: kirimLaporan,
            hapusLaporanUseCase: hapusLaporan,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: DashboardPage(),
    );
  }
}
