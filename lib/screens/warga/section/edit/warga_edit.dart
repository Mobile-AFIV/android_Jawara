import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class WargaEdit extends StatefulWidget {
  const WargaEdit({super.key});

  @override
  State<WargaEdit> createState() => _WargaEditState();
}

class _WargaEditState extends State<WargaEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Warga"),
      ),
    );
  }
}