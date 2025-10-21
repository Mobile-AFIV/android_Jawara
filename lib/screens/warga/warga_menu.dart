import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/widget/menu_card_item.dart';

class WargaMenu extends StatefulWidget {
  const WargaMenu({super.key});

  @override
  State<WargaMenu> createState() => _WargaMenuState();
}

class _WargaMenuState extends State<WargaMenu> with TickerProviderStateMixin {
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

  List<Map<String, dynamic>> get menuItems => [
        {
          'title': 'Data Warga',
          'subtitle': 'Kelola data warga RT/RW',
          'icon': Icons.people,
          'color': const Color(0xFF4A90E2),
          'route': 'warga_section',
          'badgeCount': 0,
        },
        {
          'title': 'Data Keluarga',
          'subtitle': 'Informasi kartu keluarga',
          'icon': Icons.family_restroom,
          'color': const Color(0xFF7B68EE),
          'route': 'keluarga',
          'badgeCount': 0,
        },
        {
          'title': 'Data Rumah',
          'subtitle': 'Daftar rumah & hunian',
          'icon': Icons.home,
          'color': const Color(0xFF50C878),
          'route': 'rumah',
          'badgeCount': 0,
        },
        {
          'title': 'Penerimaan Warga',
          'subtitle': 'Permohonan warga baru',
          'icon': Icons.person_add,
          'color': const Color(0xFFFF6B6B),
          'route': 'penerimaan_warga',
          'badgeCount': 3, // Example badge count
        },
        {
          'title': 'Mutasi Keluarga',
          'subtitle': 'Perpindahan & perubahan',
          'icon': Icons.swap_horiz,
          'color': const Color(0xFFFFA500),
          'route': 'mutasi_keluarga',
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
              // Header Section
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
                            'Manajemen Warga',
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
                        'Kelola data kependudukan RT/RW Anda',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Grid
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

              // Statistics Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                color: Color(0xFF4A90E2),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Statistik Singkat',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStatItem(
                            'Total Warga',
                            '156',
                            Icons.people,
                            const Color(0xFF4A90E2),
                          ),
                          const Divider(height: 24),
                          _buildStatItem(
                            'Keluarga Terdaftar',
                            '45',
                            Icons.family_restroom,
                            const Color(0xFF7B68EE),
                          ),
                          const Divider(height: 24),
                          _buildStatItem(
                            'Rumah Aktif',
                            '42',
                            Icons.home,
                            const Color(0xFF50C878),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}