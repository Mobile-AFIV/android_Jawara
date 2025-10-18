import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class ManajemenPenggunaSection extends StatelessWidget {
  const ManajemenPenggunaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pengguna"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(),
            DataTable(
              columns: const [
                DataColumn(label: Text('NO')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Status')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Andi')),
                  DataCell(Text('Andi1@gmail.com')),
                  DataCell(Text('Diterima')),
                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Budi')),
                  DataCell(Text('Budi@gmail.com')),
                  DataCell(Text('Diterima')),
                ]),
              ],
            ),
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the TambahPenggunaSection when the button is pressed
          context.pushNamed('tambah_pengguna');
        },
        child: const Icon(Icons.add), backgroundColor: AppStyles.primaryColor, 
        foregroundColor: Colors.white,
        tooltip: 'Tambah Pengguna',
    )
    );
  }
}
