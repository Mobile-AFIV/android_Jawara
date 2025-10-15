import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:intl/intl.dart';


class MutasiKeluargaTambah extends StatefulWidget {
  const MutasiKeluargaTambah({super.key});

  @override
  State<MutasiKeluargaTambah> createState() => _MutasiKeluargaTambahState();
}

class _MutasiKeluargaTambahState extends State<MutasiKeluargaTambah> {
  // You can add state variables here
  String? _selectedMutasi;
  String? _selectedKeluarga;
  final TextEditingController _mutasiController = TextEditingController();
  DateTime? _selectedDate;

  // Jenis Mutasi
  final List<String> _mutasiList = [
    'Pindah Rumah',
    'Keluar Rumah'
  ];

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
      helpText: 'Pilih Tanggal Mutasi',
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
        title: const Text("Buat Mutasi Keluarga"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jenis Mutasi",
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
                  hint: const Text("-- Pilih Jenis Mutasi --"),
                  value: _selectedMutasi,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMutasi = newValue;
                    });
                  },
                  items: _mutasiList
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
              "Keluarga",
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
              "Alasan Mutasi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100, // Set a fixed height to make it taller
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: TextField(
                controller: _mutasiController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Masukkan alasan disini",
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Tanggal Mutasi",
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

  @override
  void dispose() {
    // Clean up controller when the widget is disposed
    _mutasiController.dispose();
    super.dispose();
  }
}