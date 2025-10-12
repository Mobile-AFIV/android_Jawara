import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class BottomNavMenu extends StatefulWidget {
  final Widget child;

  const BottomNavMenu({super.key, required this.child});

  @override
  State<BottomNavMenu> createState() => _BottomNavMenuState();
}

class _BottomNavMenuState extends State<BottomNavMenu> {
  int activeMenuIndex = 0;

  final List<String> routeName = [
    'dashboard',
    'warga',
    'pemasukan',
    'kegiatan',
    'lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jawara Pintar"),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedIconTheme: IconThemeData(
          color: AppStyles.primaryColor,
        ),
        selectedItemColor: AppStyles.primaryColor,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: activeMenuIndex,
        onTap: (value) {
          setState(() {
            activeMenuIndex = value;
          });
          context.goNamed(routeName[value]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Warga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Keuangan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}
