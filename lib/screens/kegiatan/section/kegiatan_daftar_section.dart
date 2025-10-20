import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KegiatanDaftarSection extends StatelessWidget {
  const KegiatanDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kegiatan Daftar"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildKegiatanCard(
            context,
            namaKegiatan: 'Rapat RT 05',
            date: '25 Oktober 2023',
            penanggungJawab: 'Pak RT',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          context.pushNamed('kegiatan_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String namaKegiatan,
    required String date,
    required String penanggungJawab,
    required Color statusColor,
  }) {
    return Card(
      child: ListTile(
        title: Text(namaKegiatan),
        subtitle: Text('$penanggungJawab - $date'),
        trailing: ElevatedButton(
        onPressed: () {
          context.pushNamed('kegiatan_detail');
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
}
