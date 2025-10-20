import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PesanWargaSection extends StatelessWidget {
  const PesanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesan Warga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildKegiatanCard(
            namaKegiatan: 'Ibu Atiqa',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla...',
            statusColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildKegiatanCard(
            namaKegiatan: 'Pak JOKO',
            isiBroadcast:
                'blabla blabla blabla blabla blabla blabla blabla blabla...',
            statusColor: Colors.green,
          ),
        ],
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
    ),
  );
}
