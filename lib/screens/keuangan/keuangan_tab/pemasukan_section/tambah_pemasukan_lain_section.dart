import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';

class TambahPemasukanLainSection extends StatefulWidget {
  const TambahPemasukanLainSection({super.key});

  @override
  State<TambahPemasukanLainSection> createState() =>
      _TambahPemasukanLainSectionState();
}

class _TambahPemasukanLainSectionState
    extends State<TambahPemasukanLainSection> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kategoriPemasukanLainMenu =
      TextEditingController();
  final TextEditingController tanggalPemasukanController =
      TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;
  DateTime? selectedDate;

  // Kategori FIXED (tidak dari database)
  final List<String> kategoriList = [
    "Donasi",
    "Dana Bantuan Pemerintah",
    "Sumbangan Swadaya",
    "Hasil Usaha Kampung",
    "Pendapatan Lainnya",
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      final cloudinary =
          CloudinaryPublic('dpoffkpkg', 'jawara_mobile', cache: false);
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: 'penerimaan_warga'),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  Future<void> _submitForm() async {
    // Validasi
    if (namaController.text.isEmpty ||
        kategoriPemasukanLainMenu.text.isEmpty ||
        nominalController.text.isEmpty ||
        selectedDate == null ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Upload image
      final buktiUrl = await _uploadImageToCloudinary(selectedImage!);

      // Save to Firestore
      await PemasukanService.instance.createPemasukan(
        nama: namaController.text.trim(),
        kategori: kategoriPemasukanLainMenu.text,
        tanggal: selectedDate!,
        nominal: int.parse(nominalController.text),
        verifikator: 'Admin Jawara',
        buktiUrl: buktiUrl,
      );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemasukan berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Tambah Pemasukan Lain",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 1 / 2,
                  child: const Text(
                    "Buat Pemasukan Non Iuran Baru",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Nama Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: namaController,
                  hintText: "Masukkan nama pemasukan",
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tanggal Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: const Locale('id', 'ID'),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        tanggalPemasukanController.text =
                            "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: tanggalPemasukanController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Pilih tanggal",
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        suffixIcon: const Icon(Icons.calendar_today_rounded,
                            color: Colors.grey, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppStyles.primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Kategori Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                DropdownMenuTheme(
                  data: DropdownMenuThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusColor: AppStyles.primaryColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  ),
                  child: DropdownMenu<String>(
                    menuStyle: MenuStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      maximumSize: WidgetStatePropertyAll(
                        Size(MediaQuery.sizeOf(context).width - 24, 200),
                      ),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 12)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    selectedTrailingIcon:
                        const Icon(Icons.keyboard_arrow_up_rounded),
                    controller: kategoriPemasukanLainMenu,
                    hintText: "Pilih kategori pemasukan",
                    width: double.maxFinite,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: kategoriList.map((k) {
                      return DropdownMenuEntry<String>(value: k, label: k);
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        if (value == null) {
                          kategoriPemasukanLainMenu.clear();
                          return;
                        }
                        kategoriPemasukanLainMenu.text = value;
                      });
                    },
                    closeBehavior: DropdownMenuCloseBehavior.all,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Nominal Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: nominalController,
                  hintText: "Contoh: 150000",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12), // Max 12 digit
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Bukti Pemasukan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 48, color: Colors.grey.shade600),
                              const SizedBox(height: 8),
                              Text(
                                'Upload bukti pemasukan\n(.png/.jpg)',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text("Simpan"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomButton(
                        customBackgroundColor: AppStyles.errorColor,
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("Batal"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
