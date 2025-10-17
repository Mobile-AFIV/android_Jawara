import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';

class LaporanTab extends StatelessWidget {
  const LaporanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadingSection(
            headingText: "Lihat dan cetak laporan keuangan",
            subHeadingText: "Cetak Laporan",
            lainnyaOnPressed: () => context.pushNamed('cetak_laporan'),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue.shade50,
            child: const Center(child: Text("Body")),
          ),

          HeadingSection(
            headingText: "Rekapitulasi seluruh pemasukan",
            subHeadingText: "Laporan Pemasukan",
            lainnyaOnPressed: () => context.pushNamed('laporan_Pemasukan'),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue.shade50,
            child: const Center(child: Text("Body")),
          ),

          HeadingSection(
            headingText: "Rekapitulasi seluruh pengeluaran",
            subHeadingText: "Laporan Pengeluaran",
            lainnyaOnPressed: () => context.pushNamed('laporan_pengeluaran'),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue.shade50,
            child: const Center(child: Text("Body")),
          ),

        ],
      ),
    );
  }
}
