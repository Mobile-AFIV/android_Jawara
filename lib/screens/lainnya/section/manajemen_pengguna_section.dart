import 'package:flutter/material.dart';
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
  final TextEditingController namaLengkapCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController telpCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController roleCtrl = TextEditingController();

  final List<String> roleOptions = ['Admin', 'Ketua RW', 'Ketua RT', 'Sekretaris', 'Bendahara', 'Warga'];
  String selectedFilter = "Admin";
  List<String> filterOptions = ['Admin', 'Ketua RW', 'Ketua RT', 'Sekretaris', 'Bendahara', 'Warga'];

  Future<void> _showEditPengguna(UserProfile pengguna) async {
    namaLengkapCtrl.text = pengguna.namaLengkap;
    // emailCtrl.text = pengguna.email;
    telpCtrl.text = pengguna.noTelepon ?? '';
    // passwordCtrl.text = pengguna.password ?? '';
    roleCtrl.text = pengguna.role;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Pengguna"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaLengkapCtrl,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telpCtrl,
                decoration: const InputDecoration(labelText: "Nomor HP"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: roleCtrl.text.isNotEmpty ? roleCtrl.text : null,
                decoration: const InputDecoration(labelText: "Role"),
                items: roleOptions.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  roleCtrl.text = value ?? '';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ManajemenPenggunaService.instance.updateManajemenPengguna(
                id: pengguna.uid,
                penggunaBaru: {
                  "nama": namaLengkapCtrl.text,
                  "email": emailCtrl.text,
                  "password": passwordCtrl.text,
                  "telp": telpCtrl.text,
                  "role": roleCtrl.text,
                },
              );

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Simpan"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  Future<void> _showTambahPengguna() async {
    namaLengkapCtrl.clear();
    roleCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
    telpCtrl.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Pengguna"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaLengkapCtrl,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Role"),
                items: roleOptions.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  roleCtrl.text = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telpCtrl,
                decoration: const InputDecoration(labelText: "Nomor HP"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ManajemenPenggunaService.instance.createManajemenPengguna(
                namaLengkap: namaLengkapCtrl.text,
                role: roleCtrl.text,
                email: emailCtrl.text,
                password: passwordCtrl.text,
                telp: telpCtrl.text,
                isActive: true,
              );

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Simpan"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
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
                selectedFilter = value ?? "Admin";
              });
            },
            itemBuilder: (context) {
              return filterOptions.map((filter) {
                return PopupMenuItem(
                  value: filter,
                  child: Text(filter),
                );
              }).toList();
            },
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: FutureBuilder<List<UserProfile>>(
      //     future: ManajemenPenggunaService.instance.getAllManajemenPengguna(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(child: CircularProgressIndicator());
      //       } else if (snapshot.hasError) {
      //         return Center(child: Text("Error: ${snapshot.error}"));
      //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //         return const Center(child: Text("Tidak ada pengguna."));
      //       }
      //
      //       var pengguna = snapshot.data!;
      //
      //       // Apply filter
      //       if (selectedFilter != "Semua") {
      //         pengguna = pengguna
      //             .where((user) => user.role == selectedFilter)
      //             .toList();
      //       }
      //
      //       if (pengguna.isEmpty) {
      //         return Center(
      //           child: Text("Tidak ada pengguna dengan role '$selectedFilter'."),
      //         );
      //       }
      //
      //       return ListView.builder(
      //         itemCount: pengguna.length,
      //         itemBuilder: (context, i) {
      //           final user = pengguna[i];
      //
      //           return Container(
      //             margin: const EdgeInsets.only(bottom: 14),
      //             decoration: BoxDecoration(
      //               color: Colors.blue.shade50,
      //               borderRadius: BorderRadius.circular(14),
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: const Color.fromARGB(38, 10, 150, 150),
      //                   blurRadius: 6,
      //                   offset: const Offset(0, 3),
      //                 ),
      //               ],
      //             ),
      //             child: Theme(
      //               data: Theme.of(context).copyWith(
      //                 dividerColor: Colors.transparent,
      //               ),
      //               child: ExpansionTile(
      //                 tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //                 childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //                 leading: Container(
      //                   padding: const EdgeInsets.all(10),
      //                   decoration: BoxDecoration(
      //                     color: Colors.blue.shade100,
      //                     borderRadius: BorderRadius.circular(12),
      //                   ),
      //                   child: const Icon(Icons.person, color: Colors.blue),
      //                 ),
      //                 title: Text(
      //                   user.namaLengkap,
      //                   style: const TextStyle(
      //                     fontSize: 17,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //                 subtitle: Text(
      //                   "${user.role} • ${user.email}",
      //                   style: TextStyle(
      //                     color: Colors.grey.shade700,
      //                   ),
      //                 ),
      //                 children: [
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text("Nama: ${user.namaLengkap}"),
      //                       Text("Email: ${user.email}"),
      //                       Text("Nomor HP: ${user.noTelepon}"),
      //                       Text("Role: ${user.role}"),
      //                       const SizedBox(height: 16),
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           ElevatedButton.icon(
      //                             onPressed: () {
      //                               _showEditPengguna(user);
      //                             },
      //                             icon: const Icon(Icons.edit),
      //                             label: const Text("Edit"),
      //                             style: ElevatedButton.styleFrom(
      //                               backgroundColor: Colors.blue,
      //                               foregroundColor: Colors.white,
      //                             ),
      //                           ),
      //                           ElevatedButton.icon(
      //                             onPressed: () async {
      //                               final konfirm = await showDialog<bool>(
      //                                 context: context,
      //                                 builder: (context) => AlertDialog(
      //                                   title: const Text("Konfirmasi Hapus"),
      //                                   content: const Text(
      //                                       "Apakah Anda yakin ingin menghapus pengguna ini?"),
      //                                   actions: [
      //                                     TextButton(
      //                                       onPressed: () =>
      //                                           Navigator.pop(context, false),
      //                                       child: const Text("Batal"),
      //                                     ),
      //                                     TextButton(
      //                                       onPressed: () =>
      //                                           Navigator.pop(context, true),
      //                                       child: const Text("Hapus"),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               );
      //
      //                               if (konfirm == true) {
      //                                 await ManajemenPenggunaService.instance
      //                                     .deleteManajemenPengguna(user.uid);
      //                                 setState(() {});
      //                               }
      //                             },
      //                             icon: const Icon(Icons.delete),
      //                             label: const Text("Hapus"),
      //                             style: ElevatedButton.styleFrom(
      //                               backgroundColor: Colors.red,
      //                               foregroundColor: Colors.white,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
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
