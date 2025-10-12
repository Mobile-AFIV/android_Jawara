import 'package:flutter/material.dart';

class PemasukanTagihanSection extends StatelessWidget {
  const PemasukanTagihanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pemasukan Tagihan"),
      ),
      body: const Center(
        child: Text("Ini Section Pemasukan Tagihan di Menu Keuangan di Tab Pemasukan"),
      ),
    );
  }
}
