import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_dropdown_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_date_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_city_autocomplete.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_stepper_controls.dart';
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
  late TextEditingController _jobController;

  // Dropdown selections
  String? _selectedGender;
  String? _selectedReligion;
  String? _selectedBloodType;
  String? _selectedEducation;
  String? _selectedJob;
  String? _selectedFamilyRole;
  late String _selectedDomicileStatus;
  late String _selectedLifeStatus;

  // Date picker
  DateTime? _selectedDate;

  // Current step for stepper
  int _currentStep = 0;

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
    _jobController = TextEditingController(text: warga.job);

    // Set dropdown selections
    _selectedGender = warga.gender;
    _selectedReligion = warga.religion;
    _selectedBloodType = warga.bloodType;
    _selectedEducation = warga.education;

    // Handle job selection, check if it's in the standard options or custom
    if (WargaDummy.jobOptions.contains(warga.job)) {
      _selectedJob = warga.job;
    } else {
      _selectedJob = 'Lainnya';
      _jobController.text = warga.job;
    }

    _selectedFamilyRole = warga.familyRole;
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
    _jobController.dispose();
    super.dispose();
  }

  // Save the edited data
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Create updated WargaModel
      final updatedWarga = WargaModel(
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

      // Update the dummy data
      WargaDummy.dummyData[wargaIndex] = updatedWarga;

      // Show success message and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data warga berhasil disimpan')),
      );

      Navigator.pop(context, true); // Return with success result
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
        title: const Text("Edit Data Warga"),
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
            } else {
              Navigator.pop(context); // Back to previous screen
            }
          },
          controlsBuilder: (context, details) {
            final isLastStep = _currentStep == getSteps().length - 1;
            final isFirstStep = _currentStep == 0;

            return FormStepperControls(
              onContinue: details.onStepContinue!,
              onCancel: details.onStepCancel!,
              isLastStep: isLastStep,
              isFirstStep: isFirstStep,
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
            const SizedBox(height: 5),
            // Full Name
            FormTextField(
              controller: _nameController,
              label: "Nama Lengkap",
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // NIK
            FormTextField(
              controller: _nikController,
              label: "NIK",
              isRequired: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
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
            FormDropdownField<String>(
              label: "Jenis Kelamin",
              isRequired: true,
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
            FormCityAutocomplete(
              controller: _birthPlaceController,
              label: "Tempat Lahir",
            ),
            const SizedBox(height: 16),

            // Birth Date
            FormDateField(
              controller: _birthDateController,
              label: "Tanggal Lahir",
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16),

            // Phone Number
            FormTextField(
              controller: _phoneController,
              label: "Nomor Telepon",
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),

            // Religion
            FormDropdownField<String>(
              label: "Agama",
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
            FormDropdownField<String>(
              label: "Golongan Darah",
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
            const SizedBox(height: 5),
            // Education
            FormDropdownField<String>(
              label: "Pendidikan Terakhir",
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
            FormDropdownField<String>(
              label: "Pekerjaan",
              value: _selectedJob,
              items: [...WargaDummy.jobOptions].map((String job) {
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
                  FormTextField(
                    controller: _jobController,
                    label: "Pekerjaan Lainnya",
                    isRequired: _selectedJob == 'Lainnya',
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
            FormTextField(
              controller: _familyController,
              label: "Nama Keluarga",
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama keluarga tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Family Role
            FormDropdownField<String>(
              label: "Peran dalam Keluarga",
              isRequired: true,
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
            FormDropdownField<String>(
              label: "Status Penduduk",
              value: _selectedDomicileStatus,
              items: WargaDummy.statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDomicileStatus = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Life Status
            FormDropdownField<String>(
              label: "Status Kehidupan",
              value: _selectedLifeStatus,
              items: WargaDummy.lifeStatusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLifeStatus = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    ];
  }
}