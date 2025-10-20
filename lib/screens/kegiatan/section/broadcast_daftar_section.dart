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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildKegiatanCard(
            namaKegiatan: 'Rapat RT 05',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla ',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),

          _buildKegiatanCard(
            namaKegiatan: 'Rapat RT 05',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla ',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),
        ],
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

Widget _buildKegiatanCard({
  required String namaKegiatan,
  required String isiBroadcast,
  required Color statusColor,
}) {
  return Card(
    child: ListTile(
      title: Text(namaKegiatan),
      subtitle: Text(isiBroadcast),
      trailing: Icon(Icons.arrow_forward, color: statusColor),
    ),
  );
}
