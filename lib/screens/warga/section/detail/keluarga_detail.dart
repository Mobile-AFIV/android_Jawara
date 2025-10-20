import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class KeluargaDetail extends StatefulWidget {
  const KeluargaDetail({super.key});

  @override
  State<KeluargaDetail> createState() => _KeluargaDetailState();
}

class _KeluargaDetailState extends State<KeluargaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Keluarga"),
      ),
    );
  }
}