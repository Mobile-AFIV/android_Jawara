import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class MutasiKeluargaDetail extends StatefulWidget {
  const MutasiKeluargaDetail({super.key});

  @override
  State<MutasiKeluargaDetail> createState() => _MutasiKeluargaDetailState();
}

class _MutasiKeluargaDetailState extends State<MutasiKeluargaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mutasi"),
      ),
    );
  }
}