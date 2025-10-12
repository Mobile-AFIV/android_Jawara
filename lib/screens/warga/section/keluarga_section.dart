import 'package:flutter/material.dart';

class KeluargaSection extends StatelessWidget {
  const KeluargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keluarga"),
      ),
      body: const Center(
        child: Text("Ini Section Keluarga di Menu Warga"),
      ),
    );
  }
}
