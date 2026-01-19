import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk copy text
import '../../domain/entities/laporan_entity.dart';
import '../../core/constants/api_constants.dart';

class DetailLaporanPage extends StatelessWidget {
  final LaporanEntity laporan;

  const DetailLaporanPage({Key? key, required this.laporan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl =
        "${ApiConstants.uploadsUrl}/${laporan.fotoPath}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Laporan"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
                        Text(
                          "Gagal memuat gambar",
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        // Tampilkan URL agar ketahuan salahnya dimana
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(
                            "URL: $fullImageUrl",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kategori: ${laporan.kategori}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tanggal: ${laporan.tanggal}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Divider(height: 30),
                  Text(
                    "Deskripsi:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(laporan.deskripsi, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
