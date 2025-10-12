import 'package:flutter/material.dart';

class DashboardKegiatanSection extends StatelessWidget {
  const DashboardKegiatanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Kegiatan"),
      ),
      body: const Center(
        child: Text("Ini Section Dashboard Kegiatan di Menu Dashboard"),
      ),
    );
  }
}
