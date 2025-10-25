import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LainnyaMenu extends StatefulWidget {
  const LainnyaMenu({super.key});

  @override
  State<LainnyaMenu> createState() => _LainnyaMenuState();
}

class _LainnyaMenuState extends State<LainnyaMenu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ini Menu Lainnya"),
          TextButton(
            onPressed: () => context.pushNamed('channel_transfer'),
            child: const Text("Ke Section Channel transfer"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('log_aktivitas'),
            child: const Text("Ke Section Log Aktivitas"),
          ),
          TextButton(
            onPressed: () => context.pushNamed('manajemen_pengguna'),
            child: const Text("Ke Section Manajemen Pengguna"),
          ),
        ],
      ),
    );
  }
}
