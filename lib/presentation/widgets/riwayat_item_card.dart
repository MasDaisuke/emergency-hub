import 'package:flutter/material.dart';
import '../../domain/entities/laporan_entity.dart';

class RiwayatItemCard extends StatelessWidget {
  final LaporanEntity laporan;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const RiwayatItemCard({
    Key? key,
    required this.laporan,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.emergency, color: Colors.white),
        ),
        title: Text(laporan.kategori, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${laporan.deskripsi}\n${laporan.tanggal}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}