import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_action_buttons.dart';
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

  // Dropdown options (moved from MutasiKeluargaDummy)
  final List<String> _familyOptions = [
    'Keluarga A',
    'Keluarga B',
    'Keluarga C'
  ];
  final List<String> _mutationTypeOptions = [
    'Pindah Rumah',
    'Pindah Masuk',
    'Keluar Wilayah'
  ];

  // Helper method to get status color based on mutation type
  Color _getStatusColor(String mutationType) {
    switch (mutationType) {
      case 'Pindah Masuk':
        return Colors.green;
      case 'Keluar Wilayah':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

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

        // Get status color based on mutation type
        final statusColor = _getStatusColor(_selectedMutationType!);

        // Create data map for Firestore
        final newMutasi = {
          'familyName': _selectedFamily!,
          'date': _dateController.text,
          'mutationType': _selectedMutationType!,
          'statusColor': statusColor.value,
          'oldAddress': _oldAddressController.text,
          'newAddress': _newAddressController.text,
          'reason': _reasonController.text,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('mutasi_keluarga')
            .add(newMutasi);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Data mutasi keluarga berhasil ditambahkan')),
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
              // Basic information card
              FormCard(
                title: "Informasi Dasar",
                children: [
                  // Family selection
                  FormDropdownField<String>(
                    label: "Keluarga",
                    isRequired: true,
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
                  ),
                  const SizedBox(height: 16),

                  // Mutation type selection
                  FormDropdownField<String>(
                    label: "Jenis Mutasi",
                    isRequired: true,
                    value: _selectedMutationType,
                    items: _mutationTypeOptions.map((String type) {
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
                  ),
                  const SizedBox(height: 16),

                  // Date of mutation
                  FormDateField(
                    controller: _dateController,
                    label: "Tanggal Mutasi",
                    isRequired: true,
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ],
              ),

              // Address card
              FormCard(
                title: "Alamat",
                children: [
                  // Show/hide fields based on mutation type
                  if (_selectedMutationType == null ||
                      _selectedMutationType == 'Pindah Rumah' ||
                      _selectedMutationType == 'Keluar Wilayah')
                    Column(
                      children: [
                        FormTextField(
                          controller: _oldAddressController,
                          label: "Alamat Lama",
                          isRequired: _selectedMutationType == 'Pindah Rumah' ||
                              _selectedMutationType == 'Keluar Wilayah',
                          validator: (value) {
                            if ((_selectedMutationType == 'Pindah Rumah' ||
                                    _selectedMutationType ==
                                        'Keluar Wilayah') &&
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
                    FormTextField(
                      controller: _newAddressController,
                      label: "Alamat Baru",
                      isRequired: _selectedMutationType == 'Pindah Rumah' ||
                          _selectedMutationType == 'Pindah Masuk',
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

              // Reason card
              FormCard(
                title: "Alasan",
                children: [
                  FormTextField(
                    controller: _reasonController,
                    label: "Alasan Mutasi",
                    maxLines: 3,
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
