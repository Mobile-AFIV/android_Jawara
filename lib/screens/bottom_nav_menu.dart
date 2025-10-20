import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_appbar.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class BottomNavMenu extends StatefulWidget {
  final GoRouterState state;
  final Widget child;

  const BottomNavMenu({super.key, required this.state, required this.child});

  @override
  State<BottomNavMenu> createState() => _BottomNavMenuState();
}

class _BottomNavMenuState extends State<BottomNavMenu> {
  int activeMenuIndex = 0;

  final List<String> routerName = [
    'dashboard',
    'warga',
    'pemasukan',
    'kegiatan',
    'lainnya',
  ];

  final List<String> routerPath = [
    'dashboard',
    'warga',
    'keuangan',
    'kegiatan',
    'lainnya',
  ];

  int getCurrentIndex(BuildContext context) {
    final String currentRouteName = widget.state.matchedLocation.split('/')[1];
    return routerPath.indexOf(currentRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      body: widget.child,
      bottomNavigationBar: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              // color: Colors.black26,
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: getCurrentIndex(context),
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
            context.goNamed(routerName[value]);
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
      ),
    );
  }
}
