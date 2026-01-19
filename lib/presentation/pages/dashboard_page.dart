import 'package:flutter/material.dart';
import '../../domain/entities/kategori_entity.dart';
import '../widgets/instansi_card_widget.dart';
import 'form_lapor_page.dart';
import 'riwayat_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  final List<KategoriEntity> instansiList = [
    KategoriEntity(nama: 'Polisi', nomor: '110', iconName: 'police'),
    KategoriEntity(nama: 'Ambulans', nomor: '118', iconName: 'ambulance'),
    KategoriEntity(nama: 'Pemadam', nomor: '113', iconName: 'fire'),
    KategoriEntity(nama: 'BNPB', nomor: '117', iconName: 'bnpb'),
    KategoriEntity(nama: 'PLN', nomor: '123', iconName: 'pln'),
    KategoriEntity(nama: 'Derek', nomor: '14080', iconName: 'tow'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Hub"),
        backgroundColor: Colors.redAccent, // Warna header merah
        foregroundColor: Colors.white,
      ),

      Divider(), // Garis pemisah
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                // Panggil fungsi logout dari Provider
                await Provider.of<AuthProvider>(context, listen: false).logout();
                
                // Lempar balik ke halaman Login
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (_) => LoginPage()), 
                  (route) => false
                );
              },
            ),

      // ====================================
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
                  childAspectRatio: 1.2, // Mengatur rasio lebar:tinggi kartu
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

