import 'package:flutter/material.dart';

class PesanWargaSection extends StatelessWidget {
  const PesanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesan Warga"),
      ),
      body: const Center(
        child: Text("Ini Section Pesan warga di Menu Kegiatan"),
      ),
    );
  }
}
