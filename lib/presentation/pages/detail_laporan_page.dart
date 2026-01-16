import 'package:flutter/material.dart';
import '../../domain/entities/laporan_entity.dart';
import '../../core/constants/api_constants.dart';

class DetailLaporanPage extends StatelessWidget {
  final LaporanEntity laporan;

  const DetailLaporanPage({Key? key, required this.laporan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Laporan")),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              "${ApiConstants.uploadsUrl}/${laporan.fotoPath}",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori: ${laporan.kategori}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Tanggal: ${laporan.tanggal}",
                  style: TextStyle(color: Colors.grey),
                ),
                Divider(),
                Text(
                  "Deskripsi:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(laporan.deskripsi, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
