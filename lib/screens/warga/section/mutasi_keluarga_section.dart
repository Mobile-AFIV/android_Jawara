import 'package:flutter/material.dart';

class MutasiKeluargaSection extends StatelessWidget {
  const MutasiKeluargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutasi Keluarga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Data Mutasi Keluarga',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Keluarga')),
                DataColumn(label: Text('Jenis Mutasi')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('1')),
                  const DataCell(Text('25 Oktober 2023')),
                  const DataCell(Text('Keluarga Jeha')),
                  DataCell(
                    Chip(
                      label: const Text('Pindah Masuk'),
                      backgroundColor: Colors.green[100],
                      labelStyle: TextStyle(color: Colors.green[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('2')),
                  const DataCell(Text('30 November 2023')),
                  const DataCell(Text('Keluarga Fikri')),
                  DataCell(
                    Chip(
                      label: const Text('Pindah Keluar'),
                      backgroundColor: Colors.orange[100],
                      labelStyle: TextStyle(color: Colors.orange[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('3')),
                  const DataCell(Text('15 Januari 2024')),
                  const DataCell(Text('Keluarga Ahmad')),
                  DataCell(
                    Chip(
                      label: const Text('Kelahiran'),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('4')),
                  const DataCell(Text('7 Maret 2024')),
                  const DataCell(Text('Keluarga Santoso')),
                  DataCell(
                    Chip(
                      label: const Text('Kematian'),
                      backgroundColor: Colors.grey[300],
                      labelStyle: TextStyle(color: Colors.grey[800]),
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