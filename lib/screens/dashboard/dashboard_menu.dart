import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardMenu extends StatelessWidget {
  const DashboardMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ini Menu Dashboard"),
          TextButton(
            onPressed: () => context.pushNamed('dashboard_kegiatan'),
            child: const Text("Ke Section Dashboard Kegiatan"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('dashboard_kependudukan'),
            child: const Text("Ke Section Dashboard Kependudukan"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('dashboard_keuangan'),
            child: const Text("Ke Section Dashboard Keuangan"),
          ),
        ],
      ),
    );
  }
}
