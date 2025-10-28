import 'package:flutter/material.dart';

class DashboardKependudukanSection extends StatelessWidget {
  const DashboardKependudukanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Kependudukan"),
      ),
      body: const Center(
        child: Text("Ini Section Dashboard Kependudukan di Menu Dashboard"),
      ),
    );
  }
}
