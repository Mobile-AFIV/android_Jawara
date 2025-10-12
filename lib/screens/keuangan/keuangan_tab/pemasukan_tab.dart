import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PemasukanTab extends StatelessWidget {
  const PemasukanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ini Tab Pemasukan di Menu Keuangan"),
          TextButton(
            onPressed: () => context.pushNamed('kategori_iuran'),
            child: Text("Ke Section Kategori Iuran"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('pemasukan_tagihan'),
            child: Text("Ke Section Pemasukan Tagihan"),
          ),
        ],
      ),
    );
  }
}
