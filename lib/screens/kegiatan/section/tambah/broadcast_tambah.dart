import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

// Model
import 'package:jawara_pintar/models/broadcast.dart';

// Firebase service
import 'package:jawara_pintar/services/broadcast_service.dart';

class BroadcastTambah extends StatefulWidget {
  const BroadcastTambah({super.key});

  @override
  State<BroadcastTambah> createState() => _BroadcastTambahState();
}

class _BroadcastTambahState extends State<BroadcastTambah> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final BroadcastService _broadcastService = BroadcastService.instance;

  XFile? _imageFile;
  File? _pdfFile;

  int _currentStep = 0;
  bool _isLoading = false;

  // ---------------------------
  // PICK IMAGE
  // ---------------------------
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = picked);
    }
  }

  // ---------------------------
  // PICK PDF
  // ---------------------------
  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _pdfFile = File(result.files.single.path!));
    }
  }

  // ---------------------------
  // SAVE BROADCAST TO FIRESTORE
  // ---------------------------
  Future<void> _saveBroadcast() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Convert XFile/File ke List<String> path
      final List<String> lampiranGambar =
          _imageFile != null ? [_imageFile!.path] : [];
      final List<String> lampiranPdf =
          _pdfFile != null ? [_pdfFile!.path] : [];

      // Buat object baru
      final newData = BroadcastModel(
        nama: _judulController.text,
        isi: _isiController.text,
        tanggal: _tanggalController.text.isEmpty
            ? DateTime.now().toIso8601String().split("T").first
            : _tanggalController.text,
        dibuatOleh: "Warga RT 01",
        lampiranGambar: lampiranGambar,
        lampiranPdf: lampiranPdf,
      );

      // Simpan ke Firestore
      await _broadcastService.addBroadcast(newData);

      // Tutup halaman
      Navigator.pop(context);
    } catch (e) {
      debugPrint("ERROR SAVE BROADCAST: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  // ---------------------------
  // UI
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Broadcast")),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep == 1) {
                  _saveBroadcast();
                } else {
                  setState(() => _currentStep++);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep--);
              },
              steps: [
                Step(
                  title: const Text("Informasi"),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: _judulController,
                        decoration: const InputDecoration(labelText: "Judul"),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Wajib diisi" : null,
                      ),
                      TextFormField(
                        controller: _isiController,
                        decoration: const InputDecoration(labelText: "Isi"),
                        maxLines: 3,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Wajib diisi" : null,
                      ),
                      TextFormField(
                        controller: _tanggalController,
                        decoration: const InputDecoration(
                          labelText: "Tanggal (YYYY-MM-DD)",
                        ),
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text("Lampiran"),
                  content: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Upload Gambar"),
                      ),
                      if (_imageFile != null)
                        Text("Gambar: ${_imageFile!.path.split('/').last}"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickPdf,
                        child: const Text("Upload PDF"),
                      ),
                      if (_pdfFile != null)
                        Text("PDF: ${_pdfFile!.path.split('/').last}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
