import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class LogAktivitasSection extends StatefulWidget {
  const LogAktivitasSection({super.key});

  @override
  State<LogAktivitasSection> createState() => _LogAktivitasSectionState();
}

class _LogAktivitasSectionState extends State<LogAktivitasSection> {
  List<Map<String, String>> logs = [
    {
      'deskripsi': 'Mengubah Iuran: Agustusan',
      'aktor': 'Admin Jawara',
      'waktu': '2025-08-01 10:15 AM',
    },
    {
      'deskripsi': 'Membuat Broadcast Baru: DJ Baws',
      'aktor': 'Admin Jawara',
      'waktu': '2025-08-02 02:30 PM',
    },
    {
      'deskripsi': 'Menambah Pengguna Baru: Cici Lestari',
      'aktor': 'Admin Jawara',
      'waktu': '2025-08-03 09:45 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log Aktivitas",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final item = logs[index];
          return _buildLogTile(
            context,
            index: index,
            deskripsi: item['deskripsi'] ?? '',
            aktor: item['aktor'] ?? '',
            waktu: item['waktu'] ?? '',
            extraFields: item,
          );
        },
      ),
    );
  }

  Widget _buildLogTile(
    BuildContext context, {
    required int index,
    required String deskripsi,
    required String aktor,
    required String waktu,
    required Map<String, String> extraFields,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.history,
            color: Colors.white,
            size: 22,
          ),
        ),
        title: Text(
          deskripsi,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          waktu,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Deskripsi: $deskripsi', style: const TextStyle(fontSize: 14)),
              Text('Aktor: $aktor', style: const TextStyle(fontSize: 14)),
              Text('Waktu: $waktu', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: const Text('Anda yakin ingin menghapus log ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        setState(() {
                          logs.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Log berhasil dihapus')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Hapus'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
