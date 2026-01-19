import '../../domain/entities/laporan_entity.dart';

class LaporanModel extends LaporanEntity {
  LaporanModel({
    required int id,
    required String kategori,
    required String deskripsi,
    required String fotoPath, 
    required String tanggal,
  }) : super(
         id: id,
         kategori: kategori,
         deskripsi: deskripsi,
         fotoPath: fotoPath,
         tanggal: tanggal,
       );

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    return LaporanModel(
      id: int.parse(json['id'].toString()),
      kategori: json['kategori'],
      deskripsi: json['deskripsi'],
      fotoPath: json['foto_path'] ?? '',
      tanggal: json['tanggal_lapor'],
    );
  }
}
