import 'package:flutter/material.dart';

class PenerimaanWargaSection extends StatelessWidget {
  const PenerimaanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Penerimaan Warga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('NIK')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Jenis Kelamin')),
                DataColumn(label: Text('Foto Identitas')),
                DataColumn(label: Text('Status Registrasi')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('1')),
                  const DataCell(Text('Ahmad Setiawan')),
                  const DataCell(Text('3507012345678901')),
                  const DataCell(Text('ahmad.s@email.com')),
                  const DataCell(Text('Laki-laki')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image, size: 20),
                        TextButton(
                          onPressed: () {
                            // View photo action
                          },
                          child: const Text('Lihat'),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Menunggu'),
                      backgroundColor: Colors.amber[100],
                      labelStyle: TextStyle(color: Colors.amber[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('2')),
                  const DataCell(Text('Dewi Susanti')),
                  const DataCell(Text('3507012345678902')),
                  const DataCell(Text('dewi.s@email.com')),
                  const DataCell(Text('Perempuan')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image, size: 20),
                        TextButton(
                          onPressed: () {
                            // View photo action
                          },
                          child: const Text('Lihat'),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Diterima'),
                      backgroundColor: Colors.green[100],
                      labelStyle: TextStyle(color: Colors.green[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('3')),
                  const DataCell(Text('Rudi Hartono')),
                  const DataCell(Text('3507012345678903')),
                  const DataCell(Text('rudi.h@email.com')),
                  const DataCell(Text('Laki-laki')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image, size: 20),
                        TextButton(
                          onPressed: () {
                            // View photo action
                          },
                          child: const Text('Lihat'),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Ditolak'),
                      backgroundColor: Colors.red[100],
                      labelStyle: TextStyle(color: Colors.red[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
