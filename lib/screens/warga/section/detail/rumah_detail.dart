import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class RumahDetail extends StatefulWidget {
  const RumahDetail({super.key});

  @override
  State<RumahDetail> createState() => _RumahDetailState();
}

class _RumahDetailState extends State<RumahDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rumah"),
      ),
    );
  }
}