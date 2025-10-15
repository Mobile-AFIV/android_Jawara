import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:intl/intl.dart';

class WargaTambah extends StatefulWidget {
  const WargaTambah({super.key});

  @override
  State<WargaTambah> createState() => _WargaTambahState();
}

class _WargaTambahState extends State<WargaTambah> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedKeluarga;
  String? _selectedKelamin;
  String? _selectedAgama;
  String? _selectedDarah;
  String? _selectedPeran;
  String? _selectedPendidikan;
  String? _selectedPekerjaan;
  String? _selectedStatus;

  // Dummy data untuk pilihan keluarga
  final List<String> _keluargaList = [
    'Keluarga Budi Santoso',
    'Keluarga Ahmad Wijaya',
    'Keluarga Siti Rahayu',
    'Keluarga Bambang Suprapto',
    'Keluarga Indah Permata',
    'Keluarga Agus Setiawan',
    'Keluarga Dewi Lestari',
    'Keluarga Joko Widodo',
    'Keluarga Rina Mardiana',
    'Keluarga Eko Prasetyo'
  ];

  // Kelamin
  final List<String> _kelaminList = [
    'Laki-laki',
    'Perempuan',
    'non-binary',
    'binary',
  ];

  // Agama
  final List<String> _agamaList = [
    'Islam',
    'Konghucu',
    'Hindu',
    'Budha',
    'Kristen'
  ];

  // Golongan darah
  final List<String> _darahList = [
    'A',
    'B',
    'AB',
    'O'
  ];

  // Peran keluarga
  final List<String> _peranList = [
    'Kepala keluarga',
    'Istri',
    'Anak',
    'Anggota lain'
  ];

  // Pendidikan
  final List<String> _pendidikanList = [
    'Tidak Sekolah',
    'SD',
    'SMP',
    'SMA',
    'Sarjana/Diploma'
  ];

  // Pekerjaan
  final List<String> _pekerjaanList = [
    'Tidak Bekerja',
    'Pelajar',
    'Ibu Rumah Tangga',
    'Pegawai',
    'Wirausaha',
    'Buruh',
    'Lainnya'
  ];

  // Status
  final List<String> _statusList = [
    'Aktif',
    'Tidak Aktif'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Warga"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Keluarga",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Keluarga --"),
                  value: _selectedKeluarga,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedKeluarga = newValue;
                    });
                  },
                  items: _keluargaList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Nama",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Masukkan nama lengkap",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "NIK",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nikController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan NIK sesuai KTP",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Nomor Telepon",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _teleponController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "08xxxxxx",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Tempat Lahir",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tempatLahirController,
              decoration: InputDecoration(
                hintText: "Masukkan tempat lahir",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Tanggal Lahir",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? "--/--/----"
                          : DateFormat("dd/MM/yyyy").format(_selectedDate!),
                      style: TextStyle(
                        color: _selectedDate == null
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Jenis Kelamin",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Jenis Kelamin --"),
                  value: _selectedKelamin,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedKelamin = newValue;
                    });
                  },
                  items: _kelaminList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Agama",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Agama --"),
                  value: _selectedAgama,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAgama = newValue;
                    });
                  },
                  items: _agamaList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Golongan Darah",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Golongan Darah --"),
                  value: _selectedDarah,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDarah = newValue;
                    });
                  },
                  items: _darahList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Peran Keluarga",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Peran Keluarga --"),
                  value: _selectedPeran,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeran = newValue;
                    });
                  },
                  items: _peranList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Pendidikan Terakhir",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Pendidikan Terakhir --"),
                  value: _selectedPendidikan,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPendidikan = newValue;
                    });
                  },
                  items: _pendidikanList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Pekerjaan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Jenis Pekerjaan --"),
                  value: _selectedPekerjaan,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPekerjaan = newValue;
                    });
                  },
                  items: _pekerjaanList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Status",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("-- Pilih Status --"),
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                  items: _statusList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: CustomButton(
                onPressed: () {
                  // TODO
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}