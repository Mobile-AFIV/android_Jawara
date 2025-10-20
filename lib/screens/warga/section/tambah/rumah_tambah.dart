import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
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
              // Card containing address field
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
                        "Alamat Rumah",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Full address field
                      TextFormField(
                        controller: _addressController,
                        decoration: _inputDecoration(
                          "Alamat *",
                          hintText: "Contoh: Jl. Merpati No. 5",
                          prefixIcon: Icons.home,
                        ),
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
                ),
              ),

              // Card containing status
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
                        "Status Rumah",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status radio buttons
                      ...RumahDummy.statusOptions.map((status) =>
                          RadioListTile<String>(
                            title: Text(status),
                            value: status,
                            groupValue: _selectedStatus,
                            activeColor: AppStyles.primaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                      ).toList(),

                      // Status info text
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _selectedStatus == 'Tersedia'
                              ? "Rumah ini siap untuk ditempati"
                              : "Rumah ini sudah ada penghuninya",
                          style: TextStyle(
                            color: _selectedStatus == 'Tersedia' ? Colors.green : Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Preview card
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
                        "Pratinjau",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Address preview
                      Text(
                        _addressController.text.isEmpty ? "..." : _addressController.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Status chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedStatus == 'Tersedia' ? Colors.green[100] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _selectedStatus,
                          style: TextStyle(
                            color: _selectedStatus == 'Tersedia' ? Colors.green[800] : Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  InputDecoration _inputDecoration(String label, {String? hintText, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}