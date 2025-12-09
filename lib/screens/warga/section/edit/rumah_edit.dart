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

  // Status selection
  String _selectedStatus = 'Tersedia';

  // Options for status dropdown
  final List<String> _statusOptions = ['Tersedia', 'Ditempati'];

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _loadData();
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
  }

  @override
  void dispose() {
    // Dispose controllers
    _addressController.dispose();
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

        final updatedRumah = {
          'address': _addressController.text,
          'status': _selectedStatus,
          'statusColor': statusColor.value,
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

    // Check if the house can be edited (status must be "Tersedia")
    if (rumah['status'] != null && rumah['status'] != 'Tersedia') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Data Rumah"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              const Text(
                "Hanya rumah dengan status 'Tersedia' yang dapat diedit.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    // Regular edit form for editable houses
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
                    });
                  }
                },
              ),
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
