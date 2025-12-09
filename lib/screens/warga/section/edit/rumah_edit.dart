import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahEdit extends StatefulWidget {
  final String? rumahId;
  final Map<String, dynamic>? rumahData;

  const RumahEdit({
    super.key,
    this.rumahId,
    this.rumahData,
  });

  @override
  State<RumahEdit> createState() => _RumahEditState();
}

class _RumahEditState extends State<RumahEdit> {
  Map<String, dynamic> rumah = {};
  bool _isLoading = true;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  late TextEditingController _addressController;
  late TextEditingController _moveInDateController;

  // Status selection
  String _selectedStatus = 'Tersedia';

  // Options for status dropdown
  final List<String> _statusOptions = ['Tersedia', 'Ditempati'];

  // Family selection
  String? _selectedFamily;
  List<String> _familyOptions = [];
  bool _isLoadingFamilies = true;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _moveInDateController = TextEditingController();
    _loadFamilies();
    _loadData();
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
        // Skip current house being edited
        if (doc.id != widget.rumahId) {
          final family = doc.data()['family']?.toString();
          if (family != null && family.isNotEmpty) {
            assignedFamilies.add(family);
          }
        }
      }

      // Filter out families that already have houses
      final availableFamilies = families.difference(assignedFamilies).toList();

      // Add current family to options if editing and family exists
      if (rumah['family'] != null && rumah['family'].toString().isNotEmpty) {
        final currentFamily = rumah['family'].toString();
        if (!availableFamilies.contains(currentFamily)) {
          availableFamilies.add(currentFamily);
        }
      }

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

  Future<void> _loadData() async {
    if (widget.rumahData != null) {
      setState(() {
        rumah = widget.rumahData!;
        _initializeControllers();
        _isLoading = false;
      });
    } else if (widget.rumahId != null && widget.rumahId!.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('rumah_warga')
            .doc(widget.rumahId)
            .get();

        if (doc.exists) {
          setState(() {
            rumah = doc.data()!;
            rumah['id'] = doc.id;
            _initializeControllers();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data rumah tidak ditemukan')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data: $e')),
          );
          Navigator.pop(context);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    _addressController.text = rumah['address'] ?? '';
    _selectedStatus = rumah['status'] ?? 'Tersedia';
    _selectedFamily = rumah['family']?.toString();
    _moveInDateController.text = _formatDate(DateTime.now());
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

  @override
  void dispose() {
    // Dispose controllers
    _addressController.dispose();
    _moveInDateController.dispose();
    super.dispose();
  }

  // Save the edited data
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

        // Create updated data with appropriate status color
        final MaterialColor statusColor =
            _selectedStatus == 'Tersedia' ? Colors.green : Colors.blue;

        // Get current resident history
        List<dynamic> residentHistory =
            List.from(rumah['residentHistory'] ?? []);

        // If changing from Ditempati to Tersedia, mark last resident as moved out
        final oldStatus = rumah['status']?.toString();
        if (oldStatus == 'Ditempati' && _selectedStatus == 'Tersedia') {
          // Find and update the current resident (without moveOutDate)
          for (int i = residentHistory.length - 1; i >= 0; i--) {
            if (residentHistory[i]['status'] == 'Menempati' &&
                (residentHistory[i]['moveOutDate'] == null ||
                    residentHistory[i]['moveOutDate'].toString().isEmpty)) {
              residentHistory[i]['moveOutDate'] = _formatDate(DateTime.now());
              residentHistory[i]['status'] = 'Pindah';
              break;
            }
          }
        }

        // If family changed and new family is selected, add to history
        final oldFamily = rumah['family']?.toString();
        if (_selectedFamily != null &&
            _selectedFamily!.isNotEmpty &&
            _selectedFamily != oldFamily) {
          residentHistory.add({
            'family': _selectedFamily,
            'movedInDate': _moveInDateController.text,
            'status': 'Menempati',
          });
        }

        // Clear family field if status is Tersedia
        final familyValue =
            _selectedStatus == 'Tersedia' ? '' : (_selectedFamily ?? '');

        final updatedRumah = {
          'address': _addressController.text,
          'status': _selectedStatus,
          'statusColor': statusColor.value,
          'family': familyValue,
          'residentHistory': residentHistory,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Update to Firebase
        if (widget.rumahId != null && widget.rumahId!.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('rumah_warga')
              .doc(widget.rumahId)
              .update(updatedRumah);
        }

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show success message and return
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data rumah berhasil disimpan')),
          );
          Navigator.pop(context, true); // Return with success result
        }
      } catch (e) {
        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Data Rumah"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Rumah"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // House Information Section
              const Text(
                "Data Rumah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Address
              FormTextField(
                controller: _addressController,
                label: "Alamat Rumah",
                isRequired: true,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status
              FormDropdownField<String>(
                label: "Status",
                value: _selectedStatus,
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                      // Reset family selection when changing to Tersedia
                      if (newValue == 'Tersedia') {
                        _selectedFamily = null;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Family Section (only show if status is Ditempati)
              if (_selectedStatus == 'Ditempati') ...[
                _isLoadingFamilies
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : FormDropdownField<String>(
                        label: "Keluarga Penghuni",
                        value: _familyOptions.contains(_selectedFamily)
                            ? _selectedFamily
                            : null,
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
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 32),

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
