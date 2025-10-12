import 'package:flutter/material.dart';

class PengeluaranDaftarSection extends StatelessWidget {
  const PengeluaranDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengeluaran Daftar"),
      ),
      body: const Center(
        child: Text("Ini Section Pengeluaran Daftar di Menu Keuangan di Tab Laporan"),
      ),
    );
  }
}
