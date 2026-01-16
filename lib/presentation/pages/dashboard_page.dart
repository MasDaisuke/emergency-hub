import 'package:flutter/material.dart';
import '../../domain/entities/kategori_entity.dart';
import '../widgets/instansi_card_widget.dart';

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
      //
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
                ),
                itemCount: instansiList.length,
                itemBuilder: (context, index) {
                  //
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
