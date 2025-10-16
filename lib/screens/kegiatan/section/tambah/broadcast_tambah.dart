import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ← penting, untuk ambil gambar

class BroadcastTambah extends StatefulWidget {
  const BroadcastTambah({super.key});

  @override
  State<BroadcastTambah> createState() => _BroadcastTambahState();
}

class _BroadcastTambahState extends State<BroadcastTambah> {
  final TextEditingController _judulBroadcastController =
      TextEditingController();
  final TextEditingController _isiBroadcastController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image; // ← simpan gambar yang dipilih di sini

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto berhasil dipilih: ${pickedFile.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Broadcast Baru"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulBroadcastController,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Judul Broadcast',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _isiBroadcastController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi Broadcast',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image.file(
                      File(_image!.path),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Foto'),
                ),
                
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image.file(
                      File(_image!.path),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Dokumen PDF'),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simpan data broadcast di sini
                  String judul = _judulBroadcastController.text;
                  String isi = _isiBroadcastController.text;
                  String? fotoPath = _image?.path;

                  // Contoh: Tampilkan data di konsol
                  debugPrint('Judul: $judul');
                  debugPrint('Isi: $isi');
                  debugPrint('Foto Path: $fotoPath');

                  // Kembali ke halaman sebelumnya setelah simpan
                  Navigator.pop(context);
                },
                child: const Text('Simpan Broadcast'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
