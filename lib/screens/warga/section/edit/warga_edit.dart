import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:intl/intl.dart';

class WargaEdit extends StatefulWidget {
  final int wargaIndex;
  final String? name;

  const WargaEdit({
    super.key,
    required this.wargaIndex,
    this.name,
  });

  @override
  State<WargaEdit> createState() => _WargaEditState();
}

class _WargaEditState extends State<WargaEdit> {
  late WargaModel warga;
  late int wargaIndex;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _familyController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneController;
  late TextEditingController _religionController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _educationController;
  late TextEditingController _jobController;
  late TextEditingController _familyRoleController;

  // Dropdown selections
  String _selectedGender = 'Laki-laki';
  String _selectedDomicileStatus = 'Aktif';
  String _selectedLifeStatus = 'Hidup';

  // Options for dropdown menus
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _domicileStatusOptions = ['Aktif', 'Nonaktif'];
  final List<String> _lifeStatusOptions = ['Hidup', 'Wafat'];
  final List<String> _religionOptions = ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu', 'Lainnya'];
  final List<String> _bloodTypeOptions = ['A', 'B', 'AB', 'O', 'Tidak tahu'];
  final List<String> _educationOptions = ['Tidak sekolah', 'SD/MI', 'SMP/MTs', 'SMA/SMK/MA', 'Sarjana/Diploma', 'Magister', 'Doktor'];
  final List<String> _familyRoleOptions = ['Kepala Keluarga', 'Istri', 'Anak', 'Orang Tua', 'Saudara', 'Lainnya'];

  // Date picker
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Find the warga data based on name or index
    wargaIndex = widget.wargaIndex;

    if (widget.name != null && widget.name!.isNotEmpty) {
      final index = WargaDummy.dummyData.indexWhere((w) => w.name == widget.name);
      if (index != -1) {
        wargaIndex = index;
      }
    }

    warga = WargaDummy.dummyData[wargaIndex];

    // Initialize controllers with current data
    _nameController = TextEditingController(text: warga.name);
    _nikController = TextEditingController(text: warga.nik);
    _familyController = TextEditingController(text: warga.family);
    _birthPlaceController = TextEditingController(text: warga.birthPlace);
    _birthDateController = TextEditingController(text: warga.birthDate);
    _phoneController = TextEditingController(text: warga.phoneNumber);
    _religionController = TextEditingController(text: warga.religion);
    _bloodTypeController = TextEditingController(text: warga.bloodType);
    _educationController = TextEditingController(text: warga.education);
    _jobController = TextEditingController(text: warga.job);
    _familyRoleController = TextEditingController(text: warga.familyRole);

    // Set dropdown selections
    _selectedGender = warga.gender;
    _selectedDomicileStatus = warga.domicileStatus;
    _selectedLifeStatus = warga.lifeStatus;

    // Try to parse birth date
    if (warga.birthDate.isNotEmpty) {
      try {
        // Try common date formats
        List<String> formats = [
          'dd MMMM yyyy', 'd MMMM yyyy',
          'dd MMM yyyy', 'd MMM yyyy',
          'yyyy-MM-dd', 'dd-MM-yyyy'
        ];

        for (var format in formats) {
          try {
            _selectedDate = DateFormat(format, 'id_ID').parse(warga.birthDate);
            break;
          } catch (e) {
            // Continue to next format
          }
        }
      } catch (e) {
        // If all parsing fails, don't set a date
        print("Failed to parse birth date: ${warga.birthDate}");
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _nikController.dispose();
    _familyController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _religionController.dispose();
    _bloodTypeController.dispose();
    _educationController.dispose();
    _jobController.dispose();
    _familyRoleController.dispose();
    super.dispose();
  }

  // Select date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  // Save the edited data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Create updated WargaModel
      final updatedWarga = WargaModel(
        name: _nameController.text,
        nik: _nikController.text,
        family: _familyController.text,
        gender: _selectedGender,
        domicileStatus: _selectedDomicileStatus,
        lifeStatus: _selectedLifeStatus,
        birthPlace: _birthPlaceController.text,
        birthDate: _birthDateController.text,
        phoneNumber: _phoneController.text,
        religion: _religionController.text,
        bloodType: _bloodTypeController.text,
        education: _educationController.text,
        job: _jobController.text,
        familyRole: _familyRoleController.text,
      );

      // Update the dummy data
      WargaDummy.dummyData[wargaIndex] = updatedWarga;

      // Show success message and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data warga berhasil disimpan')),
      );

      Navigator.pop(context, true); // Return with success result
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Warga"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              const Text(
                "Data Pribadi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Nama Lengkap"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // NIK
              TextFormField(
                controller: _nikController,
                decoration: _inputDecoration("NIK"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  if (value.length != 16 && value != "2222222222222222") { // Special case for test data
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Jenis Kelamin"),
                value: _selectedGender,
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Birth Place
              TextFormField(
                controller: _birthPlaceController,
                decoration: _inputDecoration("Tempat Lahir"),
              ),
              const SizedBox(height: 16),

              // Birth Date
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: _inputDecoration("Tanggal Lahir", suffixIcon: Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Religion
              TextFormField(
                controller: _religionController,
                decoration: _inputDecoration("Agama"),
              ),
              const SizedBox(height: 16),

              // Blood Type
              TextFormField(
                controller: _bloodTypeController,
                decoration: _inputDecoration("Golongan Darah"),
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration("Nomor Telepon"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Education
              TextFormField(
                controller: _educationController,
                decoration: _inputDecoration("Pendidikan Terakhir"),
              ),
              const SizedBox(height: 16),

              // Job
              TextFormField(
                controller: _jobController,
                decoration: _inputDecoration("Pekerjaan"),
              ),
              const SizedBox(height: 24),

              // Family Information Section
              const Text(
                "Data Keluarga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Family Name
              TextFormField(
                controller: _familyController,
                decoration: _inputDecoration("Keluarga"),
              ),
              const SizedBox(height: 16),

              // Family Role
              TextFormField(
                controller: _familyRoleController,
                decoration: _inputDecoration("Peran dalam Keluarga"),
              ),
              const SizedBox(height: 24),

              // Status Information Section
              const Text(
                "Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Domicile Status
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Status Penduduk"),
                value: _selectedDomicileStatus,
                items: _domicileStatusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDomicileStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Life Status
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Status Kehidupan"),
                value: _selectedLifeStatus,
                items: _lifeStatusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLifeStatus = newValue!;
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