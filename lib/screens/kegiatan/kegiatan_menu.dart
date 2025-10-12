import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KegiatanMain extends StatefulWidget {
  const KegiatanMain({super.key});

  @override
  State<KegiatanMain> createState() => _KegiatanMainState();
}

class _KegiatanMainState extends State<KegiatanMain> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ini Menu Kegiatan"),
          TextButton(
            onPressed: () => context.pushNamed('broadcast_daftar'),
            child: Text("Ke Section Broadcast Daftar"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('kegiatan_daftar'),
            child: Text("Ke Section Kegiatan Daftar"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('pesan_warga'),
            child: Text("Ke Section Pesan Warga"),
          ),
        ],
      ),
    );
  }
}
