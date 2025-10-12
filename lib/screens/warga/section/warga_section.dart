import 'package:flutter/material.dart';

class WargaSection extends StatelessWidget {
  const WargaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warga"),
      ),
      body: const Center(
        child: Text("Ini Section Warga di Menu Warga"),
      ),
    );
  }
}
