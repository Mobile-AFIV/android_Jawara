import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:intl/intl.dart';

class WargaTambah extends StatefulWidget {
  const WargaTambah({super.key});

  @override
  State<WargaTambah> createState() => _WargaTambahState();
}

class _WargaTambahState extends State<WargaTambah> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _familyController = TextEditingController();
  TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  // Dropdown selections
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedEducation;
  String? _selectedJob;
  String? _selectedFamilyRole;
  String _selectedDomicileStatus = 'Aktif';
  String _selectedLifeStatus = 'Hidup';

  // Date picker
  DateTime? _selectedDate;

  // Current step for stepper
  int _currentStep = 0;

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _nikController.dispose();
    _familyController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  // Select date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        _birthDateController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  // Save the data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Create new WargaModel
      final newWarga = WargaModel(
        name: _nameController.text,
        nik: _nikController.text,
        family: _familyController.text,
        gender: _selectedGender ?? '',
        domicileStatus: _selectedDomicileStatus,
        lifeStatus: _selectedLifeStatus,
        birthPlace: _birthPlaceController.text,
        birthDate: _birthDateController.text,
        phoneNumber: _phoneController.text,
        religion: _selectedReligion ?? '',
        bloodType: _selectedBloodType ?? '',
        education: _selectedEducation ?? '',
        job: _selectedJob == 'Lainnya' ? _jobController.text : (_selectedJob ?? ''),
        familyRole: _selectedFamilyRole ?? '',
      );

      // Add to dummy data
      WargaDummy.addWarga(newWarga);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data warga berhasil ditambahkan')),
      );

      // Return to previous screen
      Navigator.pop(context, true);
    } else {
      // If not all fields are validated, show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi data yang diperlukan')),
      );

      // Go to first step if currently on second step
      if (_currentStep == 1) {
        setState(() {
          _currentStep = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data Warga"),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            final isLastStep = _currentStep == getSteps().length - 1;
            if (isLastStep) {
              _saveData();
            } else {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentStep == getSteps().length - 1 ? 'Simpan' : 'Lanjut',
                      ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppStyles.primaryColor,
                          side: BorderSide(color: AppStyles.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Kembali'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: getSteps(),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Data Pribadi"),
        content: Column(
          children: [
            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration("Nama Lengkap *"),
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
              decoration: _inputDecoration("NIK *"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK tidak boleh kosong';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Jenis Kelamin *"),
              value: _selectedGender,
              items: WargaDummy.genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis kelamin harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Birth Place with autocomplete
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return WargaDummy.cityOptions.where((String city) {
                  return city.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _birthPlaceController.text = selection;
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController fieldController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted
                  ) {
                _birthPlaceController = fieldController;
                return TextFormField(
                  controller: fieldController,
                  focusNode: fieldFocusNode,
                  decoration: _inputDecoration("Tempat Lahir"),
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Birth Date
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _birthDateController,
                  decoration: _inputDecoration(
                    "Tanggal Lahir",
                    suffixIcon: Icons.calendar_today,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration("Nomor Telepon"),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),

            // Religion
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Agama"),
              value: _selectedReligion,
              items: WargaDummy.religionOptions.map((String religion) {
                return DropdownMenuItem<String>(
                  value: religion,
                  child: Text(religion),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReligion = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Blood Type
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Golongan Darah"),
              value: _selectedBloodType,
              items: WargaDummy.bloodTypeOptions.map((String bloodType) {
                return DropdownMenuItem<String>(
                  value: bloodType,
                  child: Text(bloodType),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Data Tambahan"),
        content: Column(
          children: [
            // Education
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Pendidikan Terakhir"),
              value: _selectedEducation,
              items: WargaDummy.educationOptions.map((String education) {
                return DropdownMenuItem<String>(
                  value: education,
                  child: Text(education),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEducation = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Job
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Pekerjaan"),
              value: _selectedJob,
              items: [...WargaDummy.jobOptions, 'Lainnya'].map((String job) {
                return DropdownMenuItem<String>(
                  value: job,
                  child: Text(job),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJob = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Custom Job (if "Lainnya" is selected)
            if (_selectedJob == 'Lainnya')
              Column(
                children: [
                  TextFormField(
                    controller: _jobController,
                    decoration: _inputDecoration("Pekerjaan Lainnya"),
                    validator: (value) {
                      if (_selectedJob == 'Lainnya' && (value == null || value.isEmpty)) {
                        return 'Mohon isi jenis pekerjaan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Family Name
            TextFormField(
              controller: _familyController,
              decoration: _inputDecoration("Nama Keluarga *"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama keluarga tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Family Role
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Peran dalam Keluarga *"),
              value: _selectedFamilyRole,
              items: WargaDummy.familyRoleOptions.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFamilyRole = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Peran dalam keluarga harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Domicile Status
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Status Penduduk"),
              value: _selectedDomicileStatus,
              items: WargaDummy.statusOptions.map((String status) {
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
              items: WargaDummy.lifeStatusOptions.map((String status) {
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
          ],
        ),
      ),
    ];
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
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}