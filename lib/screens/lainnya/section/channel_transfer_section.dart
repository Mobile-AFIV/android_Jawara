import 'package:flutter/material.dart';

class ChannelTransferSection extends StatelessWidget {
  const ChannelTransferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Channel Transfer"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(),
            DataTable(
              columns: const [
                DataColumn(label: Text('NO')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Tipe')),
                DataColumn(label: Text('A/N')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Bank Mega')),
                  DataCell(Text('Bank')),
                  DataCell(Text('Susi')),

                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Transfer Antar Rekening')),
                  DataCell(Text('Rekening')),
                  DataCell(Text('Budi')),

                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
