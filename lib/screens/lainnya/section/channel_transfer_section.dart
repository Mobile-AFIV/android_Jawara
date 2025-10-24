import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/screens/lainnya/section/tambah_channel_transfer.dart';

class ChannelTransferSection extends StatefulWidget {
  const ChannelTransferSection({super.key});

  @override
  State<ChannelTransferSection> createState() => _ChannelTransferSectionState();
}

class _ChannelTransferSectionState extends State<ChannelTransferSection> {
  List<Map<String, String>> users = [
    {
      'nama': 'Bank Mega',
      'tipe': 'E-wallet',
      'A/N': 'Fandi Rahmad',
      'no_rek': '123-456-7890', // contoh field tambahan
    },
    {
      'nama': 'Bank BCA',
      'tipe': 'Rekening',
      'A/N': 'Ika Suryani',
      'no_rek': '098-765-4321',
    },
    {
      'nama': 'Bank Mandiri',
      'tipe': 'QRIS',
      'A/N': 'Joko Susilo',
      'no_rek': '564-738-2910',
    },
  ];

  Future<void> _editChannelDialog(int index) async {
    final user = users[index];
    final namaCtrl = TextEditingController(text: user['nama']);
    final tipeCtrl = TextEditingController(text: user['tipe']);
    final pemilikCtrl = TextEditingController(text: user['A/N']);
    final noRekCtrl = TextEditingController(text: user['no_rek']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Channel Transfer'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Channel'),
                ),
                TextField(
                  controller: tipeCtrl,
                  decoration: const InputDecoration(labelText: 'Tipe (Bank, E-wallet, QRIS)'),
                ),
                TextField(
                  controller: noRekCtrl,
                  decoration: const InputDecoration(labelText: 'Nomor Rekening / Akun'),
                ),
                TextField(
                  controller: pemilikCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Pemilik Akun'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  users[index] = {
                    'nama': namaCtrl.text,
                    'tipe': tipeCtrl.text,
                    'A/N': pemilikCtrl.text,
                    'no_rek': noRekCtrl.text,
                    'pemilik': pemilikCtrl.text,
                  };
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil diperbarui!')),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Channel Transfer",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final item = users[index];
          return _buildUserTile(
            context,
            index: index,
            nama: item['nama'] ?? '',
            tipe: item['tipe'] ?? '',
            pemilik: item['A/N'] ?? '',
            extraFields: item,
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahChannelSection(), // ⬅️ Halaman tambah
            ),
          ); 

          if (hasil != null && hasil is Map<String, String>) {
            setState(() {
              users.add(hasil);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Channel berhasil ditambahkan!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserTile(
    BuildContext context, {
    required int index,
    required String nama,
    required String tipe,
    required String pemilik,
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
          decoration: BoxDecoration(
            color: AppStyles.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance,
            color: const Color.fromARGB(255, 18, 17, 23),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                nama,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pemilik,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(tipe, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        children: [
          // Detail lengkap
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Pemilik: $pemilik', style: const TextStyle(fontSize: 14)),
              if (extraFields.containsKey('no_rek'))
                Text('No. Rekening: ${extraFields['no_rek']}', style: const TextStyle(fontSize: 14)),
              // Tambahkan field lain sesuai kebutuhan
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _editChannelDialog(index),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: const Text('Anda yakin ingin menghapus item ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Hapus')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        setState(() {
                          users.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item dihapus')));
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
