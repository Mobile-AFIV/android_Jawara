import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart'; // pastikan kamu menambahkan di pubspec.yaml

class KegiatanMenu extends StatefulWidget {
  const KegiatanMenu({super.key});

  @override
  State<KegiatanMenu> createState() => _KegiatanMenuState();
}

class _KegiatanMenuState extends State<KegiatanMenu> {
  final List<_MenuItem> menuItems = [
    _MenuItem(
      title: "Broadcast Daftar",
      icon: LucideIcons.megaphone,
      route: 'broadcast_daftar',
      color: Colors.blue,
    ),
    _MenuItem(
      title: "Kegiatan Daftar",
      icon: LucideIcons.calendarDays,
      route: 'kegiatan_daftar',
      color: Colors.green,
    ),
    _MenuItem(
      title: "Pesan Warga",
      icon: LucideIcons.messageSquare,
      route: 'pesan_warga',
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // dua kolom
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return _MenuCard(item: item);
          },
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(item.route),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: item.color),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: item.color.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final MaterialColor color;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });
}
