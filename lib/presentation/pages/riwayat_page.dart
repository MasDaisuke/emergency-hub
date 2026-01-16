import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import '../widgets/riwayat_item_card.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Laporan")),
      body: Consumer<EmergencyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.laporanList.isEmpty) {
            return Center(child: Text("Belum ada laporan"));
          }
          return ListView.builder(
            itemCount: provider.laporanList.length,
            itemBuilder: (context, index) {
              final item = provider.laporanList[index];
              return RiwayatItemCard(
                laporan: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailLaporanPage(laporan: item),
                    ),
                  );
                },
                onDelete: () {
                  Provider.of<EmergencyProvider>(
                    context,
                    listen: false,
                  ).hapusLaporan(item.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
