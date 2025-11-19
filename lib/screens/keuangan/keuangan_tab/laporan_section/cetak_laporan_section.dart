import 'package:flutter/material.dart';

class CetakLaporanSection extends StatelessWidget {
  const CetakLaporanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cetak Laporan"),
      ),
      body: const Center(
        child: Text("Ini Section Cetak Laporan di Menu Keuangan di Tab Laporan"),
      ),
    );
  }
}
