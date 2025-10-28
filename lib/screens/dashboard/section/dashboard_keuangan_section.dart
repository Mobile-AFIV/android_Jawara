import 'package:flutter/material.dart';

class DashboardKeuanganSection extends StatelessWidget {
  const DashboardKeuanganSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Keuangan"),
      ),
      body: const Center(
        child: Text("Ini Section Dashboard Keuangan di Menu Dashboard"),
      ),
    );
  }
}
