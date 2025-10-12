import 'package:flutter/material.dart';

class MutasiKeluargaSection extends StatelessWidget {
  const MutasiKeluargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mutasi Keluarga"),
      ),
      body: const Center(
        child: Text("Ini Section Mutasi Keluarga di Menu Warga"),
      ),
    );
  }
}
