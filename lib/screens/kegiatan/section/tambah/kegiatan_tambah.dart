import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Widget lokal
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';

// Model + Firestore service
import 'package:jawara_pintar/models/kegiatan.dart';

import 'package:jawara_pintar/services/kegiatan_service.dart';

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
  final TextEditingController _anggaranController = TextEditingController();

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

  // Save data ke Firestore
  Future<void> _saveData() async {
    if (_tanggalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanggal kegiatan wajib diisi")),
      );
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Ambil user saat ini dari Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan masuk terlebih dahulu")),
        );
        return;
      }

      // Gunakan displayName jika ada, fallback ke email atau uid
      final pembuat = (user.displayName != null && user.displayName!.trim().isNotEmpty)
          ? user.displayName!
          : (user.email ?? user.uid);

      final newKegiatan = KegiatanModel(
        namaKegiatan: _namaController.text,
        kategori: _selectedKategori ?? '',
        deskripsi: _deskripsiController.text,
        tanggal: _tanggalController.text,
        lokasi: _lokasiController.text,
        penanggungJawab: _penanggungController.text,
        dibuatOleh: pembuat,
        anggaran: int.tryParse(_anggaranController.text) ?? 0,
        id: '',
      );

      try {
        await KegiatanService.instance.create(newKegiatan);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kegiatan berhasil ditambahkan")),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan kegiatan: $e")),
        );
      }
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
             const SizedBox(height: 16),
            FormTextField(
              label: "Anggaran (Rp)",
              controller: _anggaranController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Anggaran tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ];
  }
}
