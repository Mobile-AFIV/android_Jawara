import 'package:flutter/material.dart';

class KegiatanTambah extends StatefulWidget {
  const KegiatanTambah({super.key});

  @override
  State<KegiatanTambah> createState() => _KegiatanTambahState();
}

class _KegiatanTambahState extends State<KegiatanTambah> {
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _penanggungJawabController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedKategoriKegiatan;

  final List<String> _kategoriKegiatanList = [
    'Komunitas dan Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Kegiatan',
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
        title: const Text("Tambah Kegiatan Baru"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaKegiatanController,
              decoration: const InputDecoration(
                labelText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _lokasiController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _penanggungJawabController,
              decoration: const InputDecoration(
                labelText: 'Penanggung Jawab',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedKategoriKegiatan,
              items: _kategoriKegiatanList
                  .map((kategori) => DropdownMenuItem<String>(
                        value: kategori,
                        child: Text(kategori),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKategoriKegiatan = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Kategori Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Tanggal Kegiatan belum dipilih'
                        : 'Tanggal Kegiatan: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simpan data kegiatan
                  // Validasi input dan simpan ke database atau backend
                  Navigator.pop(context);
                },
                child: const Text('Simpan Kegiatan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
