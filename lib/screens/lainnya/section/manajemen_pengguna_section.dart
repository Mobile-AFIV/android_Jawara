import 'package:flutter/material.dart';

class ManajemenPenggunaSection extends StatelessWidget {
  const ManajemenPenggunaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Pengguna"),
      ),
      body: const Center(
        child: Text("Ini Section Manajemen Pengguna di Menu Lainnya"),
      ),
    );
  }
}
