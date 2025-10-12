import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PengeluaranTab extends StatelessWidget {
  const PengeluaranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ini Tab Pengeluaran di Menu Keuangan"),
          TextButton(
            onPressed: () => context.pushNamed('pengeluaran_daftar'),
            child: Text("Ke Section Pengeluaran Daftar"),
          ),
        ],
      ),
    );
  }
}
