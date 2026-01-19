import 'package:emergency_hub/data/datasources/auth_remote_datasource.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  
  // Untuk mengecek status login saat aplikasi baru dibuka
  final AuthRemoteDataSource _dataSource = AuthRemoteDataSource(); 

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await loginUseCase.execute(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e); // Debug
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await registerUseCase.execute(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await logoutUseCase.execute();
    notifyListeners();
  }

  // Cek apakah user sudah login (untuk auto-login)
  Future<bool> isUserLoggedIn() async {
    return await _dataSource.getLoginStatus();
  }
}