import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/kategori_entity.dart';
import '../widgets/instansi_card_widget.dart';
import '../providers/auth_provider.dart'; // Import AuthProvider
import 'form_lapor_page.dart';
import 'riwayat_page.dart';
import 'login_page.dart'; // Import Login Page

class DashboardPage extends StatelessWidget {
  // Data statis kategori instansi
  final List<KategoriEntity> instansiList = [
    KategoriEntity(
      nama: 'Polisi',
      nomor: '110',
      icon: Icons.local_police,
      color: Colors.blue[800]!,
    ),
    KategoriEntity(
      nama: 'Ambulans',
      nomor: '118',
      icon: Icons.medical_services,
      color: Colors.green[600]!,
    ),
    KategoriEntity(
      nama: 'Pemadam',
      nomor: '113',
      icon: Icons.local_fire_department,
      color: Colors.orange[800]!,
    ),
    KategoriEntity(
      nama: 'BNPB',
      nomor: '117',
      icon: Icons.flood,
      color: Colors.brown[600]!,
    ),
    KategoriEntity(
      nama: 'PLN',
      nomor: '123',
      icon: Icons.electric_bolt,
      color: Colors.yellow[800]!,
    ),
    KategoriEntity(
      nama: 'Derek',
      nomor: '14080',
      icon: Icons.car_crash,
      color: Colors.purple[600]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Hub"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),

      // === MENU SAMPING (DRAWER) ===
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.emergency, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menu Aplikasi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.redAccent),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.redAccent),
              title: Text("Riwayat Laporan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RiwayatPage()),
                );
              },
            ),

            // === TOMBOL LOGOUT (POSISI YANG BENAR DISINI) ===
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                // 1. Panggil fungsi logout dari Provider
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();

                // 2. Kembali ke Halaman Login & Hapus semua history navigasi sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            ),
            // ================================================
          ],
        ),
      ),

      // === ISI UTAMA HALAMAN ===
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Kategori Darurat:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: instansiList.length,
                itemBuilder: (context, index) {
                  return InstansiCardWidget(
                    instansi: instansiList[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FormLaporPage(kategori: instansiList[index].nama),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
