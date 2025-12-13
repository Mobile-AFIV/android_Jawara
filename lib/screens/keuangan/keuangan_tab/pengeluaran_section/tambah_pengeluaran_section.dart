import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/utils/cloudinary_config.dart';

class TambahPengeluaranSection extends StatefulWidget {
  const TambahPengeluaranSection({super.key});

  @override
  State<TambahPengeluaranSection> createState() =>
      _TambahPengeluaranSectionState();
}

class _TambahPengeluaranSectionState extends State<TambahPengeluaranSection> {
  final TextEditingController namaPengeluaranController =
      TextEditingController();
  final TextEditingController tanggalPengeluaranController =
      TextEditingController();
  final TextEditingController kategoriPengeluaranController =
      TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  DateTime? selectedDate;
  String? selectedKategori;
  File? _selectedImage;
  bool _isSubmitting = false;

  final ImagePicker _imagePicker = ImagePicker();
  late final CloudinaryPublic cloudinary;

  final List<String> kategoriPengeluaranList = [
    'Operasional RT/RW',
    'Kegiatan Sosial',
    'Pemeliharaan Fasilitas',
    'Pembangunan',
    'Kegiatan Warga',
    'Keamanan dan Kebersihan',
    'Lain-lain',
  ];

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryConfig.getCloudinary();
  }

  @override
  void dispose() {
    namaPengeluaranController.dispose();
    tanggalPengeluaranController.dispose();
    kategoriPengeluaranController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id').format(date);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: AppStyles.primaryColor),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AppStyles.primaryColor),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      print('Starting upload to Cloudinary...');

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'pengeluaran',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      print('Upload completed. URL: ${response.secureUrl}');

      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print('CloudinaryException: ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Gagal mengupload gambar ke Cloudinary: ${e.message}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return null;
    } catch (e) {
      print('General error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload gambar: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _submitForm() async {
    // Validasi form
    if (namaPengeluaranController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama pengeluaran harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal pengeluaran harus dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedKategori == null || selectedKategori!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori pengeluaran harus dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (nominalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nominal = int.tryParse(nominalController.text.trim());
    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal harus berupa angka positif'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String? buktiUrl;

      // Upload gambar jika ada
      if (_selectedImage != null) {
        buktiUrl = await _uploadImageToCloudinary(_selectedImage!);
        if (buktiUrl == null) {
          setState(() {
            _isSubmitting = false;
          });
          return;
        }
      }

      // Simpan data ke Firestore
      await PengeluaranService.instance.createPengeluaran(
        nama: namaPengeluaranController.text.trim(),
        kategori: selectedKategori!,
        tanggal: selectedDate!,
        nominal: nominal,
        verifikator: 'Admin Jawara', // Bisa diganti dengan user yang login
        buktiUrl: buktiUrl,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengeluaran berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pengeluaran: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      namaPengeluaranController.clear();
      tanggalPengeluaranController.clear();
      kategoriPengeluaranController.clear();
      nominalController.clear();
      selectedDate = null;
      selectedKategori = null;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Tambah Pengeluaran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Buat Pengeluaran Baru",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Nama Pengeluaran
              const Text(
                "Nama Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              CustomTextField(
                hintText: "Masukkan nama pengeluaran",
                controller: namaPengeluaranController,
              ),
              const SizedBox(height: 16),

              // Tanggal Pengeluaran
              const Text(
                "Tanggal Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      tanggalPengeluaranController.text =
                          _formatDate(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: tanggalPengeluaranController,
                    decoration: InputDecoration(
                      hintText: "Pilih tanggal pengeluaran",
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kategori Pengeluaran
              const Text(
                "Kategori Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                child: DropdownMenu<String>(
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  selectedTrailingIcon:
                      const Icon(Icons.keyboard_arrow_up_rounded),
                  controller: kategoriPengeluaranController,
                  hintText: "Pilih kategori pengeluaran",
                  width: double.maxFinite,
                  requestFocusOnTap: false,
                  dropdownMenuEntries: kategoriPengeluaranList.map((kategori) {
                    return DropdownMenuEntry<String>(
                      value: kategori,
                      label: kategori,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      selectedKategori = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Nominal
              const Text(
                "Nominal",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              CustomTextField(
                hintText: "Masukkan nominal pengeluaran",
                controller: nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12), // Limit 12 digit
                ],
              ),
              const SizedBox(height: 16),

              // Bukti Pengeluaran
              const Text(
                "Bukti Pengeluaran",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Pilih Gambar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : _resetForm,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: AppStyles.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: AppStyles.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      customBackgroundColor: AppStyles.primaryColor,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
