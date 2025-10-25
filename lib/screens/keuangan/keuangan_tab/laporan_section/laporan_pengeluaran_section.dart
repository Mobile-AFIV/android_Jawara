import 'package:flutter/material.dart';

class LaporanPengeluaranSection extends StatelessWidget {
  const LaporanPengeluaranSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Pengeluaran"),
      ),
      body: const Center(
        child: Text("Ini Section Laporan Pengeluaran di Menu Keuangan di Tab Laporan"),
      ),
    );
  }
}
