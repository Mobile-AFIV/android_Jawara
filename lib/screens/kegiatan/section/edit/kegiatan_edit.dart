import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Model & Service
import 'package:jawara_pintar/models/kegiatan.dart';
import 'package:jawara_pintar/services/kegiatan_service.dart';

// Widgets (Asumsi path sama)
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_city_autocomplete.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';

class KegiatanEdit extends StatefulWidget {
  // Properti untuk menerima ID dokumen Firebase
  final String kegiatanId;
  final String? title;

  const KegiatanEdit({
    super.key,
    required this.kegiatanId,
    this.title,
  });

  @override
  State<KegiatanEdit> createState() => _KegiatanEditState();
}

class _KegiatanEditState extends State<KegiatanEdit> {
  // Gunakan nullable karena data diambil secara asinkron
  KegiatanModel? _kegiatan;
  bool _isLoading = true;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  late TextEditingController _namaKegiatanController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tanggalController;
  late TextEditingController _lokasiController;
  late TextEditingController _penanggungJawabController;
  late TextEditingController _dibuatOlehController;

  // Custom: To handle documentation editing (simplified with URL text fields)
  late List<TextEditingController> _dokumentasiControllers;

  // Dropdown selection
  String? _selectedKategori;

  // Date picker
  DateTime? _selectedDate;

  // Current step for stepper
  int _currentStep = 0;

  // Opsi Kategori (Ganti dengan data real jika ada service khusus)
  final List<String> _kategoriOptions = const [
    'Sosial',
    'Pendidikan',
    'Keagamaan',
    'Lingkungan',
    'Kesehatan',
    'Olahraga',
    'Pelatihan',
    'Rapat',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _fetchKegiatan();
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> _fetchKegiatan() async {
    try {
      // 1. Ambil dokumen dari Firebase
      final docSnapshot = await FirebaseFirestore.instance
          .collection('kegiatan')
          .doc(widget.kegiatanId)
          .get();

      if (docSnapshot.exists) {
        _kegiatan = KegiatanModel.fromFirestore(docSnapshot);

        // 2. Inisialisasi Controllers dan State
        _namaKegiatanController =
            TextEditingController(text: _kegiatan!.namaKegiatan);
        _deskripsiController =
            TextEditingController(text: _kegiatan!.deskripsi);
        _tanggalController = TextEditingController(text: _kegiatan!.tanggal);
        _lokasiController = TextEditingController(text: _kegiatan!.lokasi);
        _penanggungJawabController =
            TextEditingController(text: _kegiatan!.penanggungJawab);
        _dibuatOlehController =
            TextEditingController(text: _kegiatan!.dibuatOleh);

        // Set Kategori
        _selectedKategori = _kategoriOptions.contains(_kegiatan!.kategori)
            ? _kegiatan!.kategori
            : null;

        // Set Tanggal
        if (_kegiatan!.tanggal.isNotEmpty) {
          try {
            // Asumsikan format tanggal disimpan sebagai 'yyyy-MM-dd'
            _selectedDate = DateFormat('yyyy-MM-dd').parse(_kegiatan!.tanggal);
          } catch (_) {
            // Jika parsing gagal, tanggal akan tetap null
          }
        }

        // Inisialisasi Dokumentasi Controllers
        _dokumentasiControllers = _kegiatan!.dokumentasi
            .map((url) => TextEditingController(text: url))
            .toList();
      } else {
        // Dokumen tidak ditemukan
        _kegiatan = null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      // Tampilkan error ke user jika perlu
      _kegiatan = null;
    } finally {
      // Update state setelah fetch selesai
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Pastikan controllers sudah terinisialisasi sebelum dispose
    if (!_isLoading && _kegiatan != null) {
      _namaKegiatanController.dispose();
      _deskripsiController.dispose();
      _tanggalController.dispose();
      _lokasiController.dispose();
      _penanggungJawabController.dispose();
      _dibuatOlehController.dispose();
      for (var controller in _dokumentasiControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  // Save the edited data to Firebase
  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 1. Kumpulkan URL dokumentasi yang telah diubah
        final updatedDokumentasi = _dokumentasiControllers
            .map((c) => c.text.trim())
            .where((url) => url.isNotEmpty)
            .toList();

        // 2. Buat Map data yang akan diupdate
        final updatedData = {
          "namaKegiatan": _namaKegiatanController.text,
          "kategori": _selectedKategori ?? '',
          "deskripsi": _deskripsiController.text,
          "tanggal": _tanggalController.text,
          "lokasi": _lokasiController.text,
          "penanggungJawab": _penanggungJawabController.text,
          "dokumentasi": updatedDokumentasi,
          // "dibuatOleh" biasanya tidak diupdate di halaman edit
        };

        // 3. Panggil service Firebase UPDATE
        await KegiatanService.instance.update(widget.kegiatanId, updatedData);

        // 4. Tampilkan pesan sukses dan kembali
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kegiatan berhasil diperbarui')),
        );

        Navigator.pop(context, true); // Return with success result
      } catch (e) {
        print("Error saving data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    } else {
      // If validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi data yang diperlukan')),
      );
      // Go to first step if currently on second step and validation fails
      if (_currentStep == 1) {
        setState(() {
          _currentStep = 0;
        });
      }
    }
  }

  void _addDocumentationField() {
    setState(() {
      _dokumentasiControllers.add(TextEditingController());
    });
  }

  void _removeDocumentationField(int index) {
    setState(() {
      _dokumentasiControllers[index].dispose();
      _dokumentasiControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_kegiatan == null
            ? "Memuat Kegiatan..."
            : "Edit Kegiatan: ${_kegiatan!.namaKegiatan}"),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kegiatan == null
              ? const Center(child: Text("Data kegiatan tidak ditemukan."))
              : Form(
                  key: _formKey,
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      final isLastStep = _currentStep == getSteps().length - 1;
                      if (isLastStep) {
                        _saveData();
                      } else {
                        // Hanya pindah ke step berikutnya jika validasi berhasil
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _currentStep += 1;
                          });
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      } else {
                        Navigator.pop(context); // Kembali
                      }
                    },
                    controlsBuilder: (context, details) {
                      final isLastStep = _currentStep == getSteps().length - 1;
                      final isFirstStep = _currentStep == 0;

                      return FormStepperControls(
                        onContinue: details.onStepContinue!,
                        onCancel: details.onStepCancel!,
                        isLastStep: isLastStep,
                        isFirstStep: isFirstStep,
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
        title: const Text("Data Utama Kegiatan"),
        content: Column(
          children: [
            const SizedBox(height: 5),
            // Nama Kegiatan
            FormTextField(
              controller: _namaKegiatanController,
              label: "Nama Kegiatan",
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama kegiatan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Kategori
            FormDropdownField<String>(
              label: "Kategori Kegiatan",
              isRequired: true,
              value: _selectedKategori,
              items: _kategoriOptions.map((String kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedKategori = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kategori harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Deskripsi
            FormTextField(
              controller: _deskripsiController,
              label: "Deskripsi Kegiatan",
              isRequired: true,
              minLines: 3,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tanggal
            FormDateField(
              controller: _tanggalController,
              label: "Tanggal Kegiatan",
              isRequired: true,
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  // Simpan tanggal dalam format standar yang konsisten (misal: 'yyyy-MM-dd')
                  _tanggalController.text =
                      DateFormat('yyyy-MM-dd').format(date);
                });
              },
            ),
            const SizedBox(height: 16),

            // Lokasi
            FormCityAutocomplete(
              controller: _lokasiController,
              label: "Lokasi Kegiatan",
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Penanggung Jawab & Dokumentasi"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            // Penanggung Jawab
            FormTextField(
              controller: _penanggungJawabController,
              label: "Penanggung Jawab",
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Penanggung jawab tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dibuat Oleh (Read-only field)
            FormTextField(
              controller: _dibuatOlehController,
              label: "Dibuat Oleh",
              readOnly: true,
              // Ganti 'decoration' dengan properti 'suffixIcon'
              suffixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 24),

            // Dokumentasi Section
            Text(
              "Dokumentasi (URL Gambar)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),

            // List Kontroler Dokumentasi
            ..._dokumentasiControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: FormTextField(
                        controller: controller,
                        label: "URL Gambar ${index + 1}",
                        keyboardType: TextInputType.url,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeDocumentationField(index),
                    ),
                  ],
                ),
              );
            }).toList(),

            // Tombol Tambah Dokumentasi
            ElevatedButton.icon(
              onPressed: _addDocumentationField,
              icon: const Icon(Icons.add),
              label: const Text('Tambah URL Gambar'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ];
  }
}
