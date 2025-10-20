import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';


class WargaDetail extends StatefulWidget {
  const WargaDetail({super.key});

  @override
  State<WargaDetail> createState() => _WargaDetailState();
}

class _WargaDetailState extends State<WargaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Warga"),
      ),
    );
  }
}