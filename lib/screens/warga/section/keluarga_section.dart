import 'package:flutter/material.dart';

class KeluargaSection extends StatelessWidget {
  const KeluargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Keluarga"),
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
                DataColumn(label: Text('Nama Keluarga')),
                DataColumn(label: Text('Kepala Keluarga')),
                DataColumn(label: Text('Alamat Rumah')),
                DataColumn(label: Text('Status Kepemilikan')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('1')),
                  const DataCell(Text('Keluarga Santoso')),
                  const DataCell(Text('Budi Santoso')),
                  const DataCell(Text('Jl. Dahlia No. 15, RT 003/RW 002')),
                  DataCell(
                    Chip(
                      label: const Text('Milik Sendiri'),
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
                  const DataCell(Text('Keluarga Rahmad')),
                  const DataCell(Text('Ahmad Rahmad')),
                  const DataCell(Text('Jl. Mawar No. 23, RT 005/RW 002')),
                  DataCell(
                    Chip(
                      label: const Text('Sewa'),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('3')),
                  const DataCell(Text('Keluarga Wijaya')),
                  const DataCell(Text('Hendra Wijaya')),
                  const DataCell(Text('Jl. Melati No. 8, RT 002/RW 003')),
                  DataCell(
                    Chip(
                      label: const Text('Milik Keluarga'),
                      backgroundColor: Colors.purple[100],
                      labelStyle: TextStyle(color: Colors.purple[800]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('4')),
                  const DataCell(Text('Keluarga Prasetyo')),
                  const DataCell(Text('Dimas Prasetyo')),
                  const DataCell(Text('Jl. Anggrek No. 42, RT 004/RW 001')),
                  DataCell(
                    Chip(
                      label: const Text('Kontrak'),
                      backgroundColor: Colors.orange[100],
                      labelStyle: TextStyle(color: Colors.orange[800]),
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
