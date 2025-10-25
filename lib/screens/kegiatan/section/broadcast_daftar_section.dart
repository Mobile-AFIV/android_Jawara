import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BroadcastDaftarSection extends StatelessWidget {
  const BroadcastDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Broadcast Daftar"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildKegiatanCard(
            context, 
            namaKegiatan: 'Rapat RT 05',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla...',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildKegiatanCard(
            context,
            namaKegiatan: 'Rapat RT 06',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla...',
            statusColor: Colors.green,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          context.pushNamed('broadcast_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildKegiatanCard(
  BuildContext context, { 
  required String namaKegiatan,
  required String isiBroadcast,
  required Color statusColor,
}) {
  return Card(
    child: ListTile(
      title: Text(namaKegiatan),
      subtitle: Text(isiBroadcast),
      trailing: ElevatedButton(
        onPressed: () {
          context.pushNamed('broadcast_detail'); 
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(8),
          backgroundColor: statusColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        child: const Icon(Icons.arrow_forward),
      ),
    ),
  );
}
