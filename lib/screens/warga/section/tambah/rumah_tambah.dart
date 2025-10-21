import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_radio_group.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahTambah extends StatefulWidget {
  const RumahTambah({super.key});

  @override
  State<RumahTambah> createState() => _RumahTambahState();
}

class _RumahTambahState extends State<RumahTambah> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controller for address
  final TextEditingController _addressController = TextEditingController();

  // Status selection (default to Available/Tersedia)
  String _selectedStatus = 'Tersedia';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Save the data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Determine status color
      final statusColor = _selectedStatus == 'Tersedia' ? Colors.green : Colors.blue;

      // Create new RumahModel
      final newRumah = RumahModel(
        address: _addressController.text,
        status: _selectedStatus,
        statusColor: statusColor,
        residentHistory: [], // New house has no resident history
      );

      // Add to dummy data
      RumahDummy.addRumah(newRumah);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data rumah berhasil ditambahkan')),
      );

      // Return to previous screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data Rumah"),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Card
              FormCard(
                title: "Alamat Rumah",
                children: [
                  FormTextField(
                    controller: _addressController,
                    label: "Alamat",
                    isRequired: true,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Helper text
                  const Text(
                    "Masukkan alamat lengkap termasuk nomor rumah",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),

              // Status Card
              FormCard(
                title: "Status Rumah",
                children: [
                  FormRadioGroup<String>(
                    value: _selectedStatus,
                    options: RumahDummy.statusOptions,
                    labels: RumahDummy.statusOptions,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
                    activeColor: AppStyles.primaryColor,
                  ),
                ],
              ),

              // Action buttons
              FormActionButtons(
                onSave: _saveData,
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}