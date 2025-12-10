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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Menu Lainnya",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildMenuButton(
            label: "Ke Section Channel Transfer",
            icon: Icons.swap_horiz,
            onTap: () => context.pushNamed('channel_transfer'),
          ),
          const SizedBox(height: 12),
          _buildMenuButton(
            label: "Ke Section Log Aktivitas",
            icon: Icons.history,
            onTap: () => context.pushNamed('log_aktivitas'),
          ),
          const SizedBox(height: 12),
          _buildMenuButton(
            label: "Ke Section Manajemen Pengguna",
            icon: Icons.group,
            onTap: () => context.pushNamed('manajemen_pengguna'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blue.shade700),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
