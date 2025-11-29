import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/widget/menu_card_item.dart';

class KegiatanMenu extends StatefulWidget {
  const KegiatanMenu({super.key});

  @override
  State<KegiatanMenu> createState() => _KegiatanMenuState();
}

class _KegiatanMenuState extends State<KegiatanMenu>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ===============================
  //           MENU ITEMS
  // ===============================
  List<Map<String, dynamic>> get menuItems => [
        {
          'title': 'Daftar kegiatan',
          'subtitle': 'Kelola data kegiatan RT/RW',
          'icon': Icons.run_circle_sharp,
          'color': const Color(0xFF4A90E2),
          'route': 'kegiatan_daftar',
          'badgeCount': 0,
        },
        {
          'title': 'Bradcast Kegiatan',
          'subtitle': 'Informasi kegiatan RT/RW',
          'icon': Icons.broadcast_on_home,
          'color': const Color(0xFF7B68EE),
          'route': 'broadcast_daftar',
          'badgeCount': 0,
        },
        {
          'title': 'Pesan Warga',
          'subtitle': 'Daftar pesan dari warga',
          'icon': Icons.notification_add,
          'color': const Color(0xFF50C878),
          'route': 'pesan_warga',
          'badgeCount': 0,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // ===============================
              //            HEADER
              // ===============================
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF4A90E2),
                        const Color(0xFF4A90E2).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Kegiatan RT/RW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kelola data kegiatan RT/RW Anda',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===============================
              //           GRID MENU
              // ===============================
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = menuItems[index];
                      return _buildAnimatedCard(item, index);
                    },
                    childCount: menuItems.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  //         CARD ANIMATED
  // ===============================
  Widget _buildAnimatedCard(Map<String, dynamic> item, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: MenuCardItem(
        title: item['title'],
        subtitle: item['subtitle'],
        icon: item['icon'],
        color: item['color'],
        badgeCount: item['badgeCount'],
        onTap: () => context.pushNamed(item['route']),
      ),
    );
  }

  // ===============================
  //         ITEM STATISTIK
  // ===============================
}
