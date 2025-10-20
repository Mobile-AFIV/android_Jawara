import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class RumahEdit extends StatefulWidget {
  const RumahEdit({super.key});

  @override
  State<RumahEdit> createState() => _RumahEditState();
}

class _RumahEditState extends State<RumahEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Rumah"),
      ),
    );
  }
}