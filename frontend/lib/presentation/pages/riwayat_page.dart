import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import 'detail_laporan_page.dart';

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<EmergencyProvider>(context, listen: false).fetchRiwayat(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgSilver = Color(0xFFF3F4F6);
    final Color textDark = Colors.blueGrey[800]!;
    final Color accentBlue = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: bgSilver,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        title: Text(
          "Riwayat Laporan",
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),

      body: Consumer<EmergencyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.laporanList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Belum ada riwayat",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(20),
            itemCount: provider.laporanList.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              final item = provider.laporanList[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailLaporanPage(laporan: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.description, color: accentBlue),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.kategori,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.tanggal,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  item.deskripsi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[300],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Hapus Laporan?"),
                                  content: Text(
                                    "Data ini tidak bisa dikembalikan.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        Provider.of<EmergencyProvider>(
                                          context,
                                          listen: false,
                                        ).hapusLaporan(item.id);
                                      },
                                      child: Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
