import 'package:flutter/material.dart';

class PenerimaanWargaSection extends StatelessWidget {
  const PenerimaanWargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Penerimaan Warga"),
      ),
      body: const Center(
        child: Text("Ini Section Penerimaan Warga di Menu Warga"),
      ),
    );
  }
}
