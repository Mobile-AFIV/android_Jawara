import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/user_app_credential.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/models/user_profile.dart';
import 'package:flutter/services.dart';
import 'package:jawara_pintar/services/manajemen_pengguna_service.dart';

class ManajemenPenggunaSection extends StatefulWidget {
  const ManajemenPenggunaSection({super.key});

  @override
  State<ManajemenPenggunaSection> createState() => _ManajemenPenggunaSectionState();
}

class _ManajemenPenggunaSectionState extends State<ManajemenPenggunaSection> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController roleCtrl = TextEditingController();

  final List<String> roleOptions = ['administrator', 'warga'];
  String selectedFilter = "Semua";
  List<String> filterOptions = ['Semua', 'administrator', 'warga'];
  bool _isLoading = false;

 Future<void> _showEditPengguna(UserAppCredential pengguna) async {
    emailCtrl.text = pengguna.email;
    roleCtrl.text = pengguna.role;
    passwordCtrl.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Pengguna"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// EMAIL READ ONLY
              TextField(
                controller: emailCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  helperText: "Email tidak dapat diubah",
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: roleCtrl.text.isNotEmpty ? roleCtrl.text : null,
                decoration: const InputDecoration(labelText: "Role"),
                items: roleOptions
                    .map((role) =>
                        DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  roleCtrl.text = value ?? '';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              try {
                setState(() => _isLoading = true);
                await ManajemenPenggunaService.instance
                    .updateManajemenPengguna(
                  uid: pengguna.uid,
                  email: emailCtrl.text,
                  role: roleCtrl.text,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengguna berhasil diupdate')),
                  );
                  Navigator.pop(context);
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }


  Future<void> _showTambahPengguna() async {
    roleCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Pengguna"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Role"),
                items: roleOptions
                    .map((role) =>
                        DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  roleCtrl.text = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              if (roleCtrl.text.isEmpty ||
                  emailCtrl.text.isEmpty ||
                  passwordCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Semua field harus diisi')),
                );
                return;
              }

              try {
                setState(() => _isLoading = true);
                await ManajemenPenggunaService.instance
                    .createManajemenPengguna(
                  email: emailCtrl.text.trim(),
                  password: passwordCtrl.text,
                  role: roleCtrl.text,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Pengguna berhasil ditambahkan')),
                  );
                  Navigator.pop(context);
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Pengguna"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Filter Role',
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) {
              return filterOptions
                  .map((filter) =>
                      PopupMenuItem(value: filter, child: Text(filter)))
                  .toList();
            },
          ),
        ],
      ),
     body: Padding(
  padding: const EdgeInsets.all(20),
  child: FutureBuilder<List<UserAppCredential>>(
    future: ManajemenPenggunaService.instance.getAllManajemenPengguna(),
    builder: (context, snapshot) {
      // LOADING
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // ERROR
      if (snapshot.hasError) {
        return Center(
          child: Text("Error: ${snapshot.error}"),
        );
      }

      // DATA KOSONG
      final List<UserAppCredential> semuaPengguna = snapshot.data ?? [];
      if (semuaPengguna.isEmpty) {
        return const Center(
          child: Text("Tidak ada pengguna."),
        );
      }

      // FILTER ROLE
      final List<UserAppCredential> penggunaTersaring =
          selectedFilter == "Semua"
              ? semuaPengguna
              : semuaPengguna
                  .where((u) => u.role == selectedFilter)
                  .toList();

      if (penggunaTersaring.isEmpty) {
        return Center(
          child: Text(
            "Tidak ada pengguna dengan role '$selectedFilter'.",
          ),
        );
      }

      // LIST VIEW
      return ListView.builder(
        itemCount: penggunaTersaring.length,
        itemBuilder: (context, i) {
          final user = penggunaTersaring[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(38, 10, 150, 150),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: Text(
                  "${user.role} • ${user.email}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${user.email}"),
                      Text("Role: ${user.role}"),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showEditPengguna(user),
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTambahPengguna,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Pengguna",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: AppStyles.primaryColor,
      ),
    );
  }
}
