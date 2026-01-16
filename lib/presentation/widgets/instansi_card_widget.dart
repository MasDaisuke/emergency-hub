import 'package:flutter/material.dart';
import '../../domain/entities/kategori_entity.dart';

class InstansiCardWidget extends StatelessWidget {
  final KategoriEntity instansi;
  final VoidCallback onTap;

  const InstansiCardWidget({
    Key? key,
    required this.instansi,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
            SizedBox(height: 10),
            Text(instansi.nama, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(instansi.nomor, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
