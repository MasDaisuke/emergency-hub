import 'dart:io'; // Untuk File (Mobile)
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import '../../core/utils/location_helper.dart'; // Pastikan import ini benar

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

  // --- 1. LOGIC AMBIL GAMBAR ---
  Future<void> _pickImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, 
        imageQuality: 50
      );
      
      if (photo != null) {
        setState(() {
          _pickedFile = photo;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ambil gambar: $e"))
      );
    }
  }

  // --- 2. LOGIC AMBIL LOKASI (GPS) ---
  Future<void> _getLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      Position position = await LocationHelper.getCurrentLocation();
      setState(() {
        // Tampilkan koordinat di TextField
        _lokasiController.text = "${position.latitude}, ${position.longitude}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text("Lokasi ditemukan!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  // --- 3. LOGIC KIRIM LAPORAN ---
  void _submit() async {
    if (_pickedFile == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto dan Deskripsi wajib diisi!")),
      );
      return;
    }

    // TRICK: Gabungkan Lokasi ke dalam Deskripsi 
    // (Supaya tidak perlu ubah Backend/Database dulu)
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
        SnackBar(backgroundColor: Colors.green, content: Text("Laporan Terkirim!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Gagal mengirim laporan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lapor: ${widget.kategori}"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // === KOTAK GAMBAR ===
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _pickedFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                _pickedFile!.path, 
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => Icon(Icons.broken_image),
                              )
                            : Image.file(
                                File(_pickedFile!.path), 
                                fit: BoxFit.cover,
                              ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
                          Text("Ambil Foto (Wajib)", style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
              ),
            ),
            
            SizedBox(height: 20),

            // === INPUT LOKASI (GPS) ===
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lokasiController,
                    readOnly: true, // Tidak bisa diketik manual
                    decoration: InputDecoration(
                      labelText: "Lokasi (Latitude, Longitude)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin_drop, color: Colors.red),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isGettingLocation ? null : _getLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                  child: _isGettingLocation 
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(Icons.my_location),
                ),
              ],
            ),

            SizedBox(height: 20),

            // === INPUT DESKRIPSI ===
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Deskripsi Kejadian",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            
            SizedBox(height: 30),

            // === TOMBOL KIRIM ===
            Consumer<EmergencyProvider>(
              builder: (context, provider, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: provider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("KIRIM LAPORAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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