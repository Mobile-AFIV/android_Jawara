import 'package:flutter/material.dart';

class LaporanPemasukanSection extends StatelessWidget {
  const LaporanPemasukanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Pemasukan"),
      ),
      body: const Center(
        child: Text("Ini Section Laporan Pemasukan di Menu Keuangan di Tab Laporan"),
      ),
    );
  }
}
