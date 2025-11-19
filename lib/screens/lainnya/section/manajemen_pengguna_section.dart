import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/screens/lainnya/section/tambah_pengguna_section.dart';

class ManajemenPenggunaSection extends StatefulWidget {
  const ManajemenPenggunaSection({super.key});

  @override
  State<ManajemenPenggunaSection> createState() => _ManajemenPenggunaSectionState();
}

class _ManajemenPenggunaSectionState extends State<ManajemenPenggunaSection> {
  List<Map<String, String>> users = [
    {
      'nama': 'Andi',
      'email': 'andi1@gmail.com',
      'status': 'aktif',
      'tipe': 'Admin',
      'pemilik': 'Andi Saputra',
      'no_rek': '1234567890',
    },
    {
      'nama': 'Budi',
      'email': 'budi2@gmail.com',
      'status': 'tidak aktif',
      'tipe': 'User',
      'pemilik': 'Budi Santoso',
    },
    {
      'nama': 'Cici',
      'email': 'cici3@gmail.com',
      'status': 'aktif',
      'tipe': 'Moderator',
      'pemilik': 'Cici Lestari',
    },
  ];

  Future<void> _editUserDialog(int index) async {
    final user = users[index];
    final namaCtrl = TextEditingController(text: user['nama']);
    final emailCtrl = TextEditingController(text: user['email']);
    final pemilikCtrl = TextEditingController(text: user['pemilik']);
    final tipeCtrl = TextEditingController(text: user['tipe']);
    String status = user['status'] ?? 'aktif';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Pengguna'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: pemilikCtrl,
                  decoration: const InputDecoration(labelText: 'Pemilik'),
                ),
                TextField(
                  controller: tipeCtrl,
                  decoration: const InputDecoration(labelText: 'Tipe'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
                    DropdownMenuItem(
                        value: 'tidak aktif', child: Text('Tidak Aktif')),
                  ],
                  onChanged: (val) {
                    if (val != null) status = val;
                  },
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
                    'email': emailCtrl.text,
                    'status': status,
                    'tipe': tipeCtrl.text,
                    'pemilik': pemilikCtrl.text,
                    if (user.containsKey('no_rek'))
                      'no_rek': user['no_rek'] ?? ''
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
          "Manajemen Pengguna",
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
            email: item['email'] ?? '',
            status: item['status'] ?? 'Tidak Aktif',
            tipe: item['tipe'] ?? '-',
            pemilik: item['pemilik'] ?? '-',
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
              builder: (_) => const TambahPenggunaSection(),
            ),
          );
          if (hasil != null && hasil is Map<String, String>) {
            setState(() {
              users.add(hasil);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pengguna berhasil ditambahkan!')),
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
    required String email,
    required String status,
    required String tipe,
    required String pemilik,
    required Map<String, String> extraFields,
  }) {
    final isActive = status.toLowerCase() == 'aktif' || status.toLowerCase() == 'active';
    final statusColor = isActive ? Colors.green : Colors.red;

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
            Icons.account_circle,
            color: Colors.white,
            size: 24,
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
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(tipe, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Pemilik: $pemilik', style: const TextStyle(fontSize: 14)),
              Text('Email: $email', style: const TextStyle(fontSize: 14)),
              if (extraFields.containsKey('no_rek'))
                Text('No. Rekening: ${extraFields['no_rek']}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _editUserDialog(index),
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Item dihapus')));
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
