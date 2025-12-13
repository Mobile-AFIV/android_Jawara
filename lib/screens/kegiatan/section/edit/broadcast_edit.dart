import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Model & Service
import 'package:jawara_pintar/models/broadcast.dart';
import 'package:jawara_pintar/services/broadcast_service.dart';

// Widgets (Asumsi path sama)
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';

class BroadcastEdit extends StatefulWidget {
  // Properti untuk menerima ID dokumen Firebase
  final String broadcastId;
  final String? title;

  const BroadcastEdit({
    super.key,
    required this.broadcastId,
    this.title,
  });

  @override
  State<BroadcastEdit> createState() => _BroadcastEditState();
}

class _BroadcastEditState extends State<BroadcastEdit> {
  // Gunakan nullable karena data diambil secara asinkron
  BroadcastModel? _broadcast;
  bool _isLoading = true;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _tanggalController;
  late TextEditingController _dibuatOlehController;

  // Date picker
  DateTime? _selectedDate;

  // Current step for stepper
  int _currentStep = 0;

  // Service instance
  final BroadcastService _broadcastService = BroadcastService.instance;

  @override
  void initState() {
    super.initState();
    _fetchBroadcast();
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> _fetchBroadcast() async {
    try {
      // Ambil dokumen dari Firebase menggunakan service
      _broadcast = await _broadcastService.getBroadcastById(widget.broadcastId);

      if (_broadcast != null) {
        // 1. Inisialisasi Controllers dan State
        _judulController = TextEditingController(text: _broadcast!.nama);
        _isiController = TextEditingController(text: _broadcast!.isi);
        _tanggalController = TextEditingController(text: _broadcast!.tanggal);
        _dibuatOlehController =
            TextEditingController(text: _broadcast!.dibuatOleh);

        // Set Tanggal
        if (_broadcast!.tanggal.isNotEmpty) {
          try {
            // Asumsikan format tanggal disimpan sebagai 'yyyy-MM-dd'
            _selectedDate = DateFormat('yyyy-MM-dd').parse(_broadcast!.tanggal);

            // Tampilkan tanggal yang sudah di-format di FormDateField
            _tanggalController.text =
                DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate!);
          } catch (_) {
            // Jika parsing gagal
          }
        }
      } else {
        // Dokumen tidak ditemukan
        _broadcast = null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      _broadcast = null;
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
    if (!_isLoading && _broadcast != null) {
      _judulController.dispose();
      _isiController.dispose();
      _tanggalController.dispose();
      _dibuatOlehController.dispose();
    }
    super.dispose();
  }

  // Save the edited data to Firebase
  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedData = {
          "nama": _judulController.text,
          "isi": _isiController.text,
          // Simpan kembali tanggal dalam format 'yyyy-MM-dd' yang konsisten
          "tanggal": _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : _tanggalController.text,

          // 'dibuatOleh' tidak diupdate di halaman edit
        };

        // 4. Panggil service Firebase UPDATE
        await _broadcastService.updateBroadcast(
            widget.broadcastId, updatedData);

        // 5. Tampilkan pesan sukses dan kembali
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data broadcast berhasil diperbarui')),
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
      if (_currentStep == 1) {
        setState(() {
          _currentStep = 0;
        });
      }
    }
  }

  void _addAttachmentField(List<TextEditingController> controllers) {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void _removeAttachmentField(
      List<TextEditingController> controllers, int index) {
    setState(() {
      controllers[index].dispose();
      controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_broadcast == null
            ? "Memuat Broadcast..."
            : "Edit Broadcast: ${_broadcast!.nama}"),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _broadcast == null
              ? const Center(child: Text("Data broadcast tidak ditemukan."))
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
        title: const Text("Data Utama Broadcast"),
        content: Column(
          children: [
            const SizedBox(height: 5),
            // Judul Broadcast
            FormTextField(
              controller: _judulController,
              label: "Judul Broadcast",
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Isi Broadcast
            FormTextField(
              controller: _isiController,
              label: "Isi Pesan Broadcast",
              isRequired: true,
              minLines: 5,
              maxLines: 10,
            ),
            const SizedBox(height: 16),

            // Tanggal
            FormDateField(
              controller: _tanggalController,
              label: "Tanggal Broadcast",
              isRequired: true,
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  // Simpan tanggal dalam format standar yang konsisten ('yyyy-MM-dd')
                  // FormDateField sendiri akan menampilkan format 'd MMMM yyyy'
                });
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Informasi Tambahan"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            // Dibuat Oleh (Read-only field)
            FormTextField(
              controller: _dibuatOlehController,
              label: "Dibuat Oleh",
              readOnly: true,
              suffixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 24),

            // Lampiran Gambar Section

            const SizedBox(height: 12),

            // List Kontroler Lampiran Gambar

            // Tombol Tambah URL Gambar
          ],
        ),
      ),
    ];
  }
}
