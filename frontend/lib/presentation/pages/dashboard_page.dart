import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/kategori_entity.dart';
import '../widgets/instansi_card_widget.dart';
import '../providers/auth_provider.dart';
import 'form_lapor_page.dart';
import 'riwayat_page.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
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
    final Color bgSilver = Color(0xFFF3F4F6);
    final Color textDark = Colors.blueGrey[800]!;

    return Scaffold(
      backgroundColor: bgSilver,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        title: Text(
          "Emergency Hub",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.emergency_outlined, size: 50, color: Colors.white),
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
              leading: Icon(Icons.dashboard_outlined, color: Colors.blue),
              title: Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text("Riwayat Laporan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RiwayatPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout", style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sapaan Header
            Text(
              "Butuh bantuan apa?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            Text(
              "Pilih layanan darurat di bawah ini",
              style: TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
            ),

            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
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
