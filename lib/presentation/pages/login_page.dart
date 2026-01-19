import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email dan Password wajib diisi")));
      return;
    }

    bool success = await authProvider.login(
      _emailController.text, 
      _passwordController.text
    );

    if (success) {
      // Pindah ke Dashboard dan hapus history halaman login (agar tidak bisa back)
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => DashboardPage())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Gagal. Cek Email/Password.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emergency, size: 80, color: Colors.redAccent),
                  SizedBox(height: 20),
                  Text("Emergency Hub", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                      child: auth.isLoading 
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                    },
                    child: Text("Belum punya akun? Daftar disini"),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}