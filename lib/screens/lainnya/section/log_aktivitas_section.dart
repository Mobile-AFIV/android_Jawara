import 'package:flutter/material.dart';

class LogAktivitasSection extends StatelessWidget {
  const LogAktivitasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Log Aktivitas"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(),
            DataTable(
              columns: const [
                DataColumn(label: Text('NO')),
                DataColumn(label: Text('Deskripsi')),
                DataColumn(label: Text('Aktor')),
                DataColumn(label: Text('Waktu')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Mengubah iuran: Agustusan')),
                  DataCell(Text('Admin Jawara')),
                  DataCell(Text('2024-06-01 08:00')),

                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Membuat broadcast baru: DJ BAWS')),
                  DataCell(Text('Admin Jawara')),
                  DataCell(Text('2024-06-01 09:30')),

                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
