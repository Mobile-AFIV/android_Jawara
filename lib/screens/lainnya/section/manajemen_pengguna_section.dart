import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

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
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the TambahPenggunaSection when the button is pressed
          context.pushNamed('tambah_pengguna');
        },
        child: Icon(Icons.add), backgroundColor: AppStyles.primaryColor, 
        foregroundColor: Colors.white,
        tooltip: 'Tambah Pengguna',
    )
    );
  }
}
