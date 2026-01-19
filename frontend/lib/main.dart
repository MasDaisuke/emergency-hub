import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/emergency_remote_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/emergency_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/get_riwayat_usecase.dart';
import 'domain/usecases/kirim_laporan_usecase.dart';
import 'domain/usecases/hapus_laporan_usecase.dart';
import 'domain/usecases/auth_usecases.dart';
import 'presentation/providers/emergency_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emergencyDataSource = EmergencyRemoteDataSource();
    final authDataSource = AuthRemoteDataSource();

    final emergencyRepository = EmergencyRepositoryImpl(remoteDataSource: emergencyDataSource);
    final authRepository = AuthRepositoryImpl(remoteDataSource: authDataSource);

    final getRiwayat = GetRiwayatUseCase(emergencyRepository);
    final kirimLaporan = KirimLaporanUseCase(emergencyRepository);
    final hapusLaporan = HapusLaporanUseCase(emergencyRepository);
    
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmergencyProvider(
            getRiwayatUseCase: getRiwayat,
            kirimLaporanUseCase: kirimLaporan,
            hapusLaporanUseCase: hapusLaporan,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Emergency Hub',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        home: AuthCheckWrapper(), 
      ),
    );
  }
}


class AuthCheckWrapper extends StatefulWidget {
  @override
  _AuthCheckWrapperState createState() => _AuthCheckWrapperState();
}

class _AuthCheckWrapperState extends State<AuthCheckWrapper> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final status = await authProvider.isUserLoggedIn();
    setState(() {
      isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      // Sedang loading cek sesi
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (isLoggedIn == true) {
      return DashboardPage();
    } else {
      return LoginPage();
    }
  }
}