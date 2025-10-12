import 'package:flutter/material.dart';

class KegiatanDaftarSection extends StatelessWidget {
  const KegiatanDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kegiatan Daftar"),
      ),
      body: const Center(
        child: Text("Ini Section Kegiatan Daftar di Menu Kegiatan"),
      ),
    );
  }
}
