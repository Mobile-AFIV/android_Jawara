import 'package:flutter/material.dart';

class BroadcastDaftarSection extends StatelessWidget {
  const BroadcastDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Broadcast Daftar"),
      ),
      body: const Center(
        child: Text("Ini Section Broadcast Daftar di Menu Kegiatan"),
      ),
    );
  }
}
