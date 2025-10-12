import 'package:flutter/material.dart';

class KategoriIuranSection extends StatelessWidget {
  const KategoriIuranSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori Iuran"),
      ),
      body: const Center(
        child: Text("Ini Section Kategori Iuran di Menu Keuangan di Tab Pemasukan"),
      ),
    );
  }
}
