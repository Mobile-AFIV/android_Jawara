import 'package:flutter/material.dart';

class WargaSection extends StatelessWidget {
  const WargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Warga"),
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
                DataColumn(label: Text('Keluarga')),
                DataColumn(label: Text('Jenis Kelamin')),
                DataColumn(label: Text('Status Domisili')),
                DataColumn(label: Text('Status Hidup')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('1')),
                  const DataCell(Text('Budi Santoso')),
                  const DataCell(Text('3507012345678901')),
                  const DataCell(Text('Kepala Keluarga')),
                  const DataCell(Text('Laki-laki')),
                  DataCell(
                    Chip(
                      label: const Text('Tetap'),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Hidup'),
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
                  const DataCell(Text('Siti Rahayu')),
                  const DataCell(Text('3507012345678902')),
                  const DataCell(Text('Istri')),
                  const DataCell(Text('Perempuan')),
                  DataCell(
                    Chip(
                      label: const Text('Tetap'),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Hidup'),
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
                  const DataCell(Text('Ahmad Fauzi')),
                  const DataCell(Text('3507012345678903')),
                  const DataCell(Text('Anak')),
                  const DataCell(Text('Laki-laki')),
                  DataCell(
                    Chip(
                      label: const Text('Tidak Tetap'),
                      backgroundColor: Colors.orange[100],
                      labelStyle: TextStyle(color: Colors.orange[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: const Text('Hidup'),
                      backgroundColor: Colors.green[100],
                      labelStyle: TextStyle(color: Colors.green[800]),
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
