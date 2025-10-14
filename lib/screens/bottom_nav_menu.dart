import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_appbar.dart';
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
      appBar: CustomAppBar(),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: activeMenuIndex,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: AppStyles.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(
          color: AppStyles.primaryColor,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
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
