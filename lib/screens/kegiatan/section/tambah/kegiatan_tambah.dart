import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';
import 'package:jawara_pintar/screens/kegiatan/section/data/kegiatan_dummy.dart'; // pastikan ada

class KegiatanTambah extends StatefulWidget {
  const KegiatanTambah({super.key});

  @override
  State<KegiatanTambah> createState() => _KegiatanTambahState();
}

class _KegiatanTambahState extends State<KegiatanTambah> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _penanggungController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  // Dropdown
  String? _selectedKategori;

  int _currentStep = 0;

  final List<String> kategoriList = [
    'Komunitas dan Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya'
  ];

  // Save data
  void _saveData() {
    // manual validasi tanggal & kategori karena FormDateField tidak punya validator
    if ((_tanggalController.text).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanggal kegiatan wajib diisi")),
      );
      // pindah ke step tanggal (misal step 0)
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final newKegiatan = KegiatanModel(
        namaKegiatan: _namaController.text,
        kategori: _selectedKategori ?? '',
        deskripsi: _deskripsiController.text,
        tanggal: _tanggalController.text, // sesuai field model
        lokasi: _lokasiController.text,
        penanggungJawab: _penanggungController.text,
        dibuatOleh: "Admin RT", // set default / nanti ambil dari user
        dokumentasi: [],
      );

      KegiatanDummy.dummyKegiatan
          .add(newKegiatan); // atau KegiatanDummy.addKegiatan jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kegiatan berhasil ditambahkan")),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kegiatan Baru"),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            bool isLast = _currentStep == getSteps().length - 1;

            if (isLast) {
              _saveData();
            } else {
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            final isLast = _currentStep == getSteps().length - 1;
            final isFirst = _currentStep == 0;

            return FormStepperControls(
              onContinue: details.onStepContinue!,
              onCancel: details.onStepCancel!,
              isLastStep: isLast,
              isFirstStep: isFirst,
            );
          },
          steps: getSteps(),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Informasi Kegiatan"),
        content: Column(
          children: [
            FormTextField(
              label: "Nama Kegiatan",
              controller: _namaController,
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormDropdownField<String>(
              label: "Kategori",
              value: _selectedKategori,
              items: kategoriList.map((k) {
                return DropdownMenuItem<String>(
                  value: k,
                  child: Text(k),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedKategori = v),
              validator: (v) =>
                  v == null || v.isEmpty ? "Pilih kategori" : null,
            ),
            const SizedBox(height: 16),
            FormDateField(
              label: "Tanggal Kegiatan",
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
        title: const Text("Detail Pelaksanaan"),
        content: Column(
          children: [
            FormTextField(
              label: "Lokasi",
              controller: _lokasiController,
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: "Penanggung Jawab",
              controller: _penanggungController,
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: "Deskripsi",
              controller: _deskripsiController,
              maxLines: 4,
            ),
          ],
        ),
      ),
    ];
  }
}
