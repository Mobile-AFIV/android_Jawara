import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

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
            const SizedBox(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
            DataTable(
              dataRowMinHeight: 40,
              dataRowMaxHeight: 60,
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('tambah_channel_transfer');
        },
        child: const Icon(Icons.add),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Channel Transfer',
      ),
    );
  }
}
