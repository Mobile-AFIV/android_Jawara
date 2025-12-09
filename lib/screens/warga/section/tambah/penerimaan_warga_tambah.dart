import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_action_buttons.dart';

class PenerimaanWargaTambah extends StatefulWidget {
  const PenerimaanWargaTambah({super.key});

  @override
  State<PenerimaanWargaTambah> createState() => _PenerimaanWargaTambahState();
}

class _PenerimaanWargaTambahState extends State<PenerimaanWargaTambah> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Dropdown selection
  String? _selectedGender;

  // Gender options
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Save to Firestore
        await FirebaseFirestore.instance.collection('penerimaan_warga').add({
          'name': _nameController.text.trim(),
          'nik': _nikController.text.trim(),
          'email': _emailController.text.trim(),
          'gender': _selectedGender,
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
