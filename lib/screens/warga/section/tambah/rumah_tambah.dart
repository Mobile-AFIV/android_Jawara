import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_radio_group.dart';
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

  // Status options (moved from RumahDummy)
  final List<String> _statusOptions = ['Tersedia', 'Ditempati'];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Save the data
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

        // Determine status color
        final statusColor =
            _selectedStatus == 'Tersedia' ? Colors.green : Colors.blue;

        // Create data map for Firestore
        final newRumah = {
          'address': _addressController.text,
          'status': _selectedStatus,
          'statusColor': statusColor.value,
          'residentHistory': [], // New house has no resident history
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance.collection('rumah').add(newRumah);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data rumah berhasil ditambahkan')),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Center(
            child: Text(
              "Tambah Data Rumah",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Address Section
          const Text(
            "Alamat Rumah",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 20),

          // Status Section
          const Text(
            "Status Rumah",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          FormRadioGroup<String>(
            value: _selectedStatus,
            options: _statusOptions,
            labels: _statusOptions,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
            activeColor: AppStyles.primaryColor,
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _saveData,
                  child: const Text("Simpan"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
