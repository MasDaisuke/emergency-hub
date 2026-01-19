import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/login.php'),
      body: {'email': email, 'password': password},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      // Simpan sesi login ke HP
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', data['data']['name']);
      return true;
    } else {
      throw Exception(data['message']);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/register.php'),
      body: {'name': name, 'email': email, 'password': password},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return true;
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data sesi
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}