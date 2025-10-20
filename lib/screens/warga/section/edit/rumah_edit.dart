import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahEdit extends StatefulWidget {
  final int rumahIndex;
  final String? address;

  const RumahEdit({
    super.key,
    required this.rumahIndex,
    this.address,
  });

  @override
  State<RumahEdit> createState() => _RumahEditState();
}

class _RumahEditState extends State<RumahEdit> {
  late RumahModel rumah;
  late int rumahIndex;

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

    // Find the rumah data based on address or index
    rumahIndex = widget.rumahIndex;

    if (widget.address != null && widget.address!.isNotEmpty) {
      final index = RumahDummy.dummyData.indexWhere((r) => r.address == widget.address);
      if (index != -1) {
        rumahIndex = index;
      }
    }

    rumah = RumahDummy.dummyData[rumahIndex];

    // Only allow editing if status is "Tersedia"
    if (rumah.status != 'Tersedia') {
      // We'll handle this in the build method to show an error
    }

    // Initialize controllers with current data
    _addressController = TextEditingController(text: rumah.address);
    _selectedStatus = rumah.status;
  }

  @override
  void dispose() {
    // Dispose controllers
    _addressController.dispose();
    super.dispose();
  }

  // Save the edited data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Create updated RumahModel with appropriate status color
      final MaterialColor statusColor = _selectedStatus == 'Tersedia' ? Colors.green : Colors.blue;

      final updatedRumah = RumahModel(
        address: _addressController.text,
        status: _selectedStatus,
        statusColor: statusColor,
        residentHistory: rumah.residentHistory, // Keep the existing history
      );

      // Update the dummy data
      RumahDummy.dummyData[rumahIndex] = updatedRumah;

      // Show success message and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data rumah berhasil disimpan')),
      );

      Navigator.pop(context, true); // Return with success result
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the house can be edited (status must be "Tersedia")
    if (rumah.status != 'Tersedia') {
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration("Alamat Rumah"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Status"),
                value: _selectedStatus,
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),

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
                      ),
                      child: const Text('Simpan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }
}