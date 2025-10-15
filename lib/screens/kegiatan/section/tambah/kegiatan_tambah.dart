import 'package:flutter/material.dart';

class KegiatanTambah extends StatefulWidget {
  const KegiatanTambah({super.key});

  @override
  State<KegiatanTambah> createState() => _KegiatanTambahState();
}

class _KegiatanTambahState extends State<KegiatanTambah> {
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();
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
        title: Text("Tambah Kegiatan Baru"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaKegiatanController,
              decoration: InputDecoration(
                labelText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _lokasiController,
              decoration: InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _penanggungJawabController,
              decoration: InputDecoration(
                labelText: 'Penanggung Jawab',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedKategoriKegiatan,
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
              decoration: InputDecoration(
                labelText: 'Kategori Kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
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
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simpan data kegiatan
                  // Validasi input dan simpan ke database atau backend
                  Navigator.pop(context);
                },
                child: Text('Simpan Kegiatan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
