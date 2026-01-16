import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';

class FormLaporPage extends StatefulWidget {
  final String kategori;
  const FormLaporPage({Key? key, required this.kategori}) : super(key: key);

  @override
  _FormLaporPageState createState() => _FormLaporPageState();
}

class _FormLaporPageState extends State<FormLaporPage> {
  final TextEditingController _descController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void _submit() async {
    if (_image == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto dan Deskripsi wajib diisi!")));
      return;
    }

    final success = await Provider.of<EmergencyProvider>(context, listen: false)
        .kirimLaporan(widget.kategori, _descController.text, _image!.path);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Laporan Terkirim!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengirim laporan")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lapor: ${widget.kategori}")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.camera_alt, size: 50), Text("Ambil Foto (Wajib)")],
                      ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Deskripsi Kejadian",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Consumer<EmergencyProvider>(
              builder: (context, provider, _) {
                return provider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text("Kirim Laporan"),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}