import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';

class BroadcastTambah extends StatefulWidget {
  const BroadcastTambah({super.key});

  @override
  State<BroadcastTambah> createState() => _BroadcastTambahState();
}

class _BroadcastTambahState extends State<BroadcastTambah> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  // File
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  File? _pdfFile;

  int _currentStep = 0;

  // Upload foto
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gambar dipilih: ${picked.name}")),
      );
    }
  }

  // Upload PDF

  /// Simpan data
  void _saveBroadcast() {
    if ((_tanggalController.text).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanggal publikasi wajib diisi")),
      );
      setState(() => _currentStep = 0);
      return;
    }

    if (_formKey.currentState!.validate()) {
      debugPrint("Judul : ${_judulController.text}");
      debugPrint("Isi : ${_isiController.text}");
      debugPrint("Tanggal : ${_tanggalController.text}");
      debugPrint("Gambar : ${_imageFile?.path}");
      debugPrint("PDF : ${_pdfFile?.path}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broadcast berhasil disimpan")),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Broadcast Baru")),
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
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (context, details) {
            return FormStepperControls(
              onContinue: details.onStepContinue!,
              onCancel: details.onStepCancel!,
              isLastStep: _currentStep == getSteps().length - 1,
              isFirstStep: _currentStep == 0,
            );
          },
          steps: getSteps(),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      // STEP 1 ────────────── Info Utama
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Informasi Broadcast"),
        content: Column(
          children: [
            FormTextField(
              label: "Judul Broadcast",
              controller: _judulController,
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: "Isi Broadcast",
              controller: _isiController,
              maxLines: 4,
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormDateField(
              label: "Tanggal Publikasi",
              controller: _tanggalController,
              onDateSelected: (date) {
                _tanggalController.text = DateFormat('yyyy-MM-dd').format(date);
              },
            ),
          ],
        ),
      ),

      // STEP 2 ────────────── Lampiran
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Lampiran"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Row(children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Upload Gambar"),
              ),
            ]),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.file(
                  File(_imageFile!.path),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 24),

            // PDF
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Implement PDF picking logic here
                  },
                  child: const Text("Upload PDF"),
                ),
              ],
            ),
            if (_pdfFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("File PDF: ${_pdfFile!.path.split('/').last}"),
              ),
          ],
        ),
      ),
    ];
  }
}
