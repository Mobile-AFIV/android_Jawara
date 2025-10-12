import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabBarKeuangan extends StatefulWidget {
  final Widget child;

  const TabBarKeuangan({super.key, required this.child});

  @override
  State<TabBarKeuangan> createState() => _TabBarKeuanganState();
}

class _TabBarKeuanganState extends State<TabBarKeuangan> {
  int activeTabIndex = 0;

  List<String> routeName = [
    'pemasukan',
    'pengeluaran',
    'laporan',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: activeTabIndex,
      length: routeName.length,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              onTap: (value) {
                setState(() {
                  activeTabIndex = value;
                });
                context.goNamed(routeName[value]);
              },
              tabs: const [
                Tab(text: "Pemasukan"),
                Tab(text: "Pengeluaran"),
                Tab(text: "Laporan"),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
