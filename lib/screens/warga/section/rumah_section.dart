import 'package:flutter/material.dart';

class RumahSection extends StatelessWidget {
  const RumahSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rumah"),
      ),
      body: const Center(
        child: Text("Ini Section Rumah di Menu Warga"),
      ),
    );
  }
}
