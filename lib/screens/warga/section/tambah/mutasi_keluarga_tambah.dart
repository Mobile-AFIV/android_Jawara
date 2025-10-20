import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:intl/intl.dart';

class MutasiKeluargaTambah extends StatefulWidget {
  const MutasiKeluargaTambah({super.key});

  @override
  State<MutasiKeluargaTambah> createState() => _MutasiKeluargaTambahState();
}

class _MutasiKeluargaTambahState extends State<MutasiKeluargaTambah> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Dropdown selections
  String? _selectedFamily;
  String? _selectedMutationType;

  // Text controllers
  final TextEditingController _oldAddressController = TextEditingController();
  final TextEditingController _newAddressController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Selected date
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize date with current date
    _dateController.text = DateFormat('d MMMM yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _oldAddressController.dispose();
    _newAddressController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Select date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyles.primaryColor,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  // Update form fields based on mutation type
  void _updateFormFields() {
    setState(() {
      if (_selectedMutationType == 'Pindah Masuk') {
        // New address is required, old address is hidden
        _oldAddressController.text = '';
      } else if (_selectedMutationType == 'Keluar Wilayah') {
        // Old address is required, new address is hidden
        _newAddressController.text = '';
      }
    });
  }

  // Save the data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Get status color based on mutation type
      final statusColor = MutasiKeluargaDummy.getStatusColor(_selectedMutationType!);

      // Create new MutasiKeluargaModel
      final newMutasi = MutasiKeluargaModel(
        familyName: _selectedFamily!,
        date: _dateController.text,
        mutationType: _selectedMutationType!,
        statusColor: statusColor,
        oldAddress: _oldAddressController.text,
        newAddress: _newAddressController.text,
        reason: _reasonController.text,
      );

      // Add to dummy data
      MutasiKeluargaDummy.addMutasi(newMutasi);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data mutasi keluarga berhasil ditambahkan')),
      );

      // Return to previous screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Mutasi Keluarga"),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card for family and mutation type
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Dasar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Family selection
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Keluarga *"),
                        value: _selectedFamily,
                        items: MutasiKeluargaDummy.familyOptions.map((String family) {
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Keluarga harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mutation type selection
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Jenis Mutasi *"),
                        value: _selectedMutationType,
                        items: MutasiKeluargaDummy.mutationTypeOptions.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMutationType = newValue;
                            _updateFormFields();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jenis mutasi harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of mutation
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dateController,
                            decoration: _inputDecoration(
                              "Tanggal Mutasi *",
                              suffixIcon: Icons.calendar_today,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal mutasi harus diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card for addresses
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alamat",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show/hide fields based on mutation type
                      if (_selectedMutationType == null ||
                          _selectedMutationType == 'Pindah Rumah' ||
                          _selectedMutationType == 'Keluar Wilayah')
                        Column(
                          children: [
                            TextFormField(
                              controller: _oldAddressController,
                              decoration: _inputDecoration("Alamat Lama *"),
                              validator: (value) {
                                if ((_selectedMutationType == 'Pindah Rumah' ||
                                    _selectedMutationType == 'Keluar Wilayah') &&
                                    (value == null || value.isEmpty)) {
                                  return 'Alamat lama harus diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      if (_selectedMutationType == null ||
                          _selectedMutationType == 'Pindah Rumah' ||
                          _selectedMutationType == 'Pindah Masuk')
                        TextFormField(
                          controller: _newAddressController,
                          decoration: _inputDecoration("Alamat Baru *"),
                          validator: (value) {
                            if ((_selectedMutationType == 'Pindah Rumah' ||
                                _selectedMutationType == 'Pindah Masuk') &&
                                (value == null || value.isEmpty)) {
                              return 'Alamat baru harus diisi';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Card for reason
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alasan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reason for mutation
                      TextFormField(
                        controller: _reasonController,
                        decoration: _inputDecoration("Alasan Mutasi"),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppStyles.primaryColor,
                        side: BorderSide(color: AppStyles.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
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

  // Helper method for consistent input decoration
  InputDecoration _inputDecoration(String label, {IconData? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
    );
  }
}