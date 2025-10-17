import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BroadcastDaftarSection extends StatelessWidget {
  const BroadcastDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Broadcast Daftar"),
      ),
      //awalnya ada consnya kenapa harus dihapus
      body: Center(
        child: Column(
          children: [
            Text("Ini Section Broadcast Daftar di Menu Kegiatan"),
            SizedBox(),
            DataTable(
              columns: const [
                DataColumn(label: Text('NO')),
                DataColumn(label: Text('tes')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Pengirim')),
                  DataCell(Text('Pengirim')),

                ]),
                DataRow(cells: [
              DataCell(Text('Andi')),
              DataCell(Text('Sistem Informasi')),
             
            ]),
              ],
              
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(), // atau RoundedRectangleBorder()
        onPressed: () {
          context.pushNamed('broadcast_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
