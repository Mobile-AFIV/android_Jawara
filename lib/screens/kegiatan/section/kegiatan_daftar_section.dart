import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KegiatanDaftarSection extends StatelessWidget {
  const KegiatanDaftarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kegiatan Daftar"),
      ),
      body: const Center(
        child: Column(
          children: [
            Text("Ini Section Kegiatan Daftar di Menu Kegiatan"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(), // atau RoundedRectangleBorder()
        onPressed: () {
          context.pushNamed('kegiatan_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
