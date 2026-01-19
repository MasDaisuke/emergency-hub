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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: instansi.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(instansi.icon, size: 32, color: instansi.color),
            ),
            SizedBox(height: 12),
            Text(
              instansi.nama,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              instansi.nomor,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
