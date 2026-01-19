import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/laporan_entity.dart';
import '../../core/constants/api_constants.dart';

class DetailLaporanPage extends StatelessWidget {
  final LaporanEntity laporan;

  const DetailLaporanPage({Key? key, required this.laporan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgSilver = Color(0xFFF3F4F6);
    final Color textDark = Colors.blueGrey[800]!;
    final Color accentBlue = Color(0xFF2196F3);

    final String fullImageUrl =
        "${ApiConstants.uploadsUrl}/${laporan.fotoPath}";

    return Scaffold(
      backgroundColor: bgSilver,
      appBar: AppBar(
        title: Text(
          "Detail Laporan",
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[100],
                      child: Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Gagal memuat gambar",
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: fullImageUrl),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "URL Link disalin ke clipboard",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: 14,
                                    color: accentBlue,
                                  ),
                                  label: Text(
                                    "Salin Link Error",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accentBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                laporan.kategori.toUpperCase(),
                                style: TextStyle(
                                  color: accentBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              laporan.tanggal,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        Divider(color: Colors.grey[200]),
                        SizedBox(height: 20),
                        Text(
                          "Deskripsi Kejadian",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgSilver.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            laporan.deskripsi,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey[700],
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
