import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';

class PengeluaranTab extends StatelessWidget {
  const PengeluaranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadingSection(
            headingText: "Kelola daftar pengeluaran anda",
            subHeadingText: "Pengeluaran Daftar",
            lainnyaOnPressed: () => context.pushNamed('pengeluaran_daftar'),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red.shade50,
            child: const Center(child: Text("Body")),
          ),

        ],
      ),
    );
  }
}
