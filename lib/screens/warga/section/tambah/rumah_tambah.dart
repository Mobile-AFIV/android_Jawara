import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_radio_group.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
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
  final TextEditingController _moveInDateController = TextEditingController();

  // Status selection (default to Available/Tersedia)
  String _selectedStatus = 'Tersedia';

  // Status options (moved from RumahDummy)
  final List<String> _statusOptions = ['Tersedia', 'Ditempati'];

  // Family selection
  String? _selectedFamily;
  List<String> _familyOptions = [];
  bool _isLoadingFamilies = true;

  @override
  void initState() {
    super.initState();
    _moveInDateController.text = _formatDate(DateTime.now());
    _loadFamilies();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _moveInDateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _loadFamilies() async {
    try {
      // Get all warga data
      final wargaSnapshot = await FirebaseFirestore.instance
          .collection('warga')
          .orderBy('family')
          .get();

      final families = <String>{};
      for (var doc in wargaSnapshot.docs) {
        final family = doc.data()['family']?.toString();
        if (family != null && family.isNotEmpty) {
          families.add(family);
        }
      }

      // Get all houses with assigned families
      final rumahSnapshot = await FirebaseFirestore.instance
          .collection('rumah_warga')
          .where('family', isNotEqualTo: '')
          .get();

      final assignedFamilies = <String>{};
      for (var doc in rumahSnapshot.docs) {
        final family = doc.data()['family']?.toString();
        if (family != null && family.isNotEmpty) {
          assignedFamilies.add(family);
        }
      }

      // Filter out families that already have houses
      final availableFamilies = families.difference(assignedFamilies).toList();

      setState(() {
        _familyOptions = availableFamilies..sort();
        _isLoadingFamilies = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFamilies = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data keluarga: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _moveInDateController.dispose();
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

        // Create resident history if family is selected
        List<Map<String, dynamic>> residentHistory = [];
        if (_selectedFamily != null && _selectedFamily!.isNotEmpty) {
          residentHistory.add({
            'family': _selectedFamily,
            'movedInDate': _moveInDateController.text,
            'status': 'Menempati',
          });
        }

        // Create data map for Firestore
        final newRumah = {
          'address': _addressController.text,
          'status': _selectedStatus,
          'statusColor': statusColor.value,
          'family': _selectedFamily ?? '',
          'residentHistory': residentHistory,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('rumah_warga')
            .add(newRumah);

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
          const SizedBox(height: 20),

          // Family Section (only show if status is Ditempati)
          if (_selectedStatus == 'Ditempati') ...[
            const Text(
              "Keluarga Penghuni",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _isLoadingFamilies
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : FormDropdownField<String>(
                    label: "Nama Keluarga",
                    value: _selectedFamily,
                    items: _familyOptions.map((String family) {
                      return DropdownMenuItem<String>(
                        value: family,
                        child: Text(family),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFamily = newValue;
                      });
                    },
                    isRequired: _selectedStatus == 'Ditempati',
                    validator: (value) {
                      if (_selectedStatus == 'Ditempati' &&
                          (value == null || value.isEmpty)) {
                        return 'Pilih keluarga penghuni';
                      }
                      return null;
                    },
                  ),
            const SizedBox(height: 8),
            const Text(
              "Pilih keluarga yang menempati rumah ini",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            FormTextField(
              controller: _moveInDateController,
              label: "Tanggal Masuk",
              isRequired: true,
              readOnly: true,
              onTap: () => _selectDate(context),
              suffixIcon: Icons.calendar_today,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih tanggal masuk';
                }
                return null;
              },
            ),
          ],
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
