import 'package:flutter/material.dart';

class LogAktivitasSection extends StatelessWidget {
  const LogAktivitasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Aktivitas"),
      ),
      body: const Center(
        child: Text("Ini Section Log Aktivitas di Menu Lainnya"),
      ),
    );
  }
}
