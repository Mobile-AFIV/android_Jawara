import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaporanTab extends StatelessWidget {
  const LaporanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ini Tab Laporan di Menu Keuangan"),
          TextButton(
            onPressed: () => context.pushNamed('cetak_laporan'),
            child: Text("Ke Section Cetak Laporan"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('laporan_Pemasukan'),
            child: Text("Ke Section Laporan Pemasukan"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('laporan_pengeluaran'),
            child: Text("Ke Section Laporan Pengeluaran"),
          ),
        ],
      ),
    );
  }
}
