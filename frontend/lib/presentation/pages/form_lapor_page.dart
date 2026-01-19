import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import '../../core/utils/location_helper.dart';

class FormLaporPage extends StatefulWidget {
  final String kategori;
  const FormLaporPage({Key? key, required this.kategori}) : super(key: key);

  @override
  _FormLaporPageState createState() => _FormLaporPageState();
}

class _FormLaporPageState extends State<FormLaporPage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isGettingLocation = false;

  Future<void> _pickImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (photo != null) setState(() => _pickedFile = photo);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error Kamera: $e")));
    }
  }

  Future<void> _getLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      Position position = await LocationHelper.getCurrentLocation();
      setState(() {
        _lokasiController.text = "${position.latitude}, ${position.longitude}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Lokasi Terkunci!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  void _submit() async {
    if (_pickedFile == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto dan Deskripsi wajib diisi!")),
      );
      return;
    }

    String finalDeskripsi = _descController.text;
    if (_lokasiController.text.isNotEmpty) {
      finalDeskripsi += "\n\n[Lokasi GPS: ${_lokasiController.text}]";
    }

    final success = await Provider.of<EmergencyProvider>(
      context,
      listen: false,
    ).kirimLaporan(widget.kategori, finalDeskripsi, _pickedFile!);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Laporan Terkirim!"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal mengirim laporan"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Tema
    final Color bgSilver = Color(0xFFF3F4F6);
    final Color textDark = Colors.blueGrey[800]!;
    final Color accentBlue = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: bgSilver,
      appBar: AppBar(
        title: Text(
          "Lapor ${widget.kategori}",
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _pickImage,
                  child: _pickedFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: kIsWeb
                              ? Image.network(
                                  _pickedFile!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_pickedFile!.path),
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bgSilver,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: accentBlue,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Ambil Foto Kejadian",
                              style: TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "(Ketuk disini)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: TextField(
                      controller: _lokasiController,
                      readOnly: true,
                      style: TextStyle(fontSize: 13, color: textDark),
                      decoration: InputDecoration(
                        hintText: "Koordinat GPS",
                        prefixIcon: Icon(
                          Icons.pin_drop,
                          color: Colors.redAccent,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: _isGettingLocation ? null : _getLocation,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4FC3F7),
                          Color(0xFF2196F3),
                        ], // Gradient Biru
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isGettingLocation
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: TextField(
                controller: _descController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Deskripsi Kejadian",
                  labelStyle: TextStyle(color: Colors.grey),
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description_outlined, color: accentBlue),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 30),
            Consumer<EmergencyProvider>(
              builder: (context, provider, _) {
                return Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF5252),
                        Color(0xFFD32F2F),
                      ], // Gradient Merah
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: provider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "KIRIM LAPORAN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
