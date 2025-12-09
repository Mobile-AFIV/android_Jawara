import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

// Widget lokal (sesuaikan path jika berbeda)
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';

// Model + Firebase service
import 'package:jawara_pintar/models/broadcast.dart';
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
  bool _isLoading = false; // Dipertahankan untuk logika _saveBroadcast

  // ---------------------------
  // PICK IMAGE
  // ---------------------------
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = picked);
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
  // SAVE BROADCAST
  // ---------------------------
  Future<void> _saveBroadcast() async {
    // Validasi di langkah terakhir (sebelum save)
    if (!_formKey.currentState!.validate()) {
      // Pindah ke langkah 0 jika validasi gagal, mirip dengan referensi Kegiatan
      setState(() => _currentStep = 0); 
      return;
    }

    setState(() => _isLoading = true);

    try {
      final lampiranGambar =
          _imageFile != null ? <String>[_imageFile!.path] : <String>[];
      final lampiranPdf =
          _pdfFile != null ? <String>[_pdfFile!.path] : <String>[];

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

      await _broadcastService.addBroadcast(newData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broadcast berhasil ditambahkan")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("ERROR SAVE BROADCAST: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Broadcast")),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            final isLast = _currentStep == getSteps().length - 1;
            if (isLast) {
              _saveBroadcast();
            } else {
              // Hanya pindah ke langkah berikutnya jika langkah saat ini valid
              if (getSteps()[_currentStep].title is Text && 
                  (getSteps()[_currentStep].title as Text).data == "Informasi Broadcast" &&
                  !_formKey.currentState!.validate()) {
                // Biarkan validasi formulir terpicu
                return;
              }
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (context, details) {
            final isLast = _currentStep == getSteps().length - 1;
            final isFirst = _currentStep == 0;
            return FormStepperControls(
              // Menonaktifkan tombol "Lanjut/Simpan" saat loading
              onContinue: _isLoading ? () {} : details.onStepContinue!,
              onCancel: details.onStepCancel!,
              isLastStep: isLast,
              isFirstStep: isFirst,
 // Tambahkan properti isLoading jika FormStepperControls mendukungnya
            );
          },
          steps: getSteps(),
        ),
      ),
      // **Indikator Loading Dihapus/Dipotong dari build()**
      // if (_isLoading)
      //   Container(
      //     color: Colors.black54,
      //     child: const Center(
      //       child: CircularProgressIndicator(color: Colors.white),
      //     ),
      //   ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Informasi Broadcast"),
        content: Column(
          children: [
            FormTextField(
              label: "Judul",
              controller: _judulController,
              validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: "Isi",
              controller: _isiController,
              maxLines: 4,
              validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormDateField(
              label: "Tanggal Broadcast",
              controller: _tanggalController,
              onDateSelected: (date) {
                _tanggalController.text = DateFormat('yyyy-MM-dd').format(date);
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Lampiran (Opsional)"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Upload Gambar"),
            ),
            const SizedBox(height: 8),
            if (_imageFile != null)
              Text("Gambar terpilih: ${_imageFile!.path.split('/').last}"),
            if (_imageFile == null)
              const Text("Belum ada gambar terpilih"),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Upload PDF"),
            ),
            const SizedBox(height: 8),
            if (_pdfFile != null)
              Text("PDF terpilih: ${_pdfFile!.path.split('/').last}"),
            if (_pdfFile == null)
              const Text("Belum ada PDF terpilih"),
          ],
        ),
      ),
    ];
  }
}