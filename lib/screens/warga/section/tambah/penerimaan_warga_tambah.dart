import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_action_buttons.dart';
import 'package:jawara_pintar/utils/cloudinary_config.dart';

class PenerimaanWargaTambah extends StatefulWidget {
  const PenerimaanWargaTambah({super.key});

  @override
  State<PenerimaanWargaTambah> createState() => _PenerimaanWargaTambahState();
}

class _PenerimaanWargaTambahState extends State<PenerimaanWargaTambah> {
  final _formKey = GlobalKey<FormState>();

  // Cloudinary instance
  late final CloudinaryPublic cloudinary;

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Dropdown selection
  String? _selectedGender;

  // Gender options
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryConfig.getCloudinary();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    super.dispose();
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
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
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

      // Upload to Cloudinary
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'penerimaan_warga',
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

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      // Validate image is selected
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto KTP harus diupload')),
        );
        return;
      }

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Upload image to Cloudinary
        final String? imageUrl =
            await _uploadImageToCloudinary(_selectedImage!);

        if (imageUrl == null) {
          if (mounted) Navigator.pop(context);
          return;
        }

        // Save to Firestore
        await FirebaseFirestore.instance.collection('penerimaan_warga').add({
          'name': _nameController.text.trim(),
          'nik': _nikController.text.trim(),
          'email': _emailController.text.trim(),
          'gender': _selectedGender,
          'ktpImageUrl': imageUrl,
          'registrationStatus': 'Menunggu',
          'rejectionReason': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data penerimaan warga berhasil ditambahkan'),
            ),
          );
        }

        // Return to previous screen
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penerimaan Warga'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Form Card
                FormCard(
                  title: 'Data Calon Warga',
                  icon: Icons.person_add,
                  children: [
                    // Name Field
                    FormTextField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      isRequired: true,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // NIK Field
                    FormTextField(
                      controller: _nikController,
                      label: 'NIK',
                      hintText: 'Masukkan NIK 16 digit',
                      isRequired: true,
                      prefixIcon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK harus diisi';
                        }
                        if (value.length != 16) {
                          return 'NIK harus 16 digit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    FormTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Masukkan email',
                      isRequired: true,
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email harus diisi';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender Dropdown
                    FormDropdownField<String>(
                      label: 'Jenis Kelamin',
                      hintText: 'Pilih jenis kelamin',
                      isRequired: true,
                      prefixIcon: Icons.wc,
                      value: _selectedGender,
                      items: _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis kelamin harus dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image Upload Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Foto KTP',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_selectedImage != null)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_selectedImage == null)
                          InkWell(
                            onTap: _showImageSourceDialog,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[50],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tap untuk upload foto KTP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kamera atau Galeri',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: OutlinedButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Ganti Foto'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                // Info Card
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Status pendaftaran akan otomatis diatur menjadi "Menunggu"',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                FormActionButtons(
                  onSave: _saveData,
                  onCancel: () => Navigator.pop(context),
                  saveLabel: 'Simpan Data',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
