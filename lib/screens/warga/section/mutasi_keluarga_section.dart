import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class MutasiKeluargaSection extends StatefulWidget {
  const MutasiKeluargaSection({super.key});

  @override
  State<MutasiKeluargaSection> createState() => _MutasiKeluargaSectionState();
}

class _MutasiKeluargaSectionState extends State<MutasiKeluargaSection>
    with TickerProviderStateMixin {
  late List<bool> _expandedList;
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
    _initFabAnimation();
    _setupScrollListener();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      MutasiKeluargaDummy.dummyData.length,
      (index) => index == 0,
    );
  }

  void _initFabAnimation() {
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutBack,
    ));

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));

    _fabController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _showFab) {
        setState(() => _showFab = false);
      } else if (_scrollController.offset <= 100 && !_showFab) {
        setState(() => _showFab = true);
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mutasi Keluarga"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() => _initExpandedList());
        },
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          itemCount: MutasiKeluargaDummy.dummyData.length,
          itemBuilder: (context, index) {
            return _buildAnimatedCard(index);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: ScaleTransition(
          scale: _fabScaleAnimation,
          child: RotationTransition(
            turns: _fabRotationAnimation,
            child: FloatingActionButton.extended(
              backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
              foregroundColor: Colors.white,
              onPressed: () async {
                await _fabController.reverse();
                
                final result = await context.pushNamed('mutasi_keluarga_tambah');
                
                _fabController.forward();
                
                if (result == true) {
                  setState(() => _initExpandedList());
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Mutasi'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final mutasi = MutasiKeluargaDummy.dummyData[index];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: ExpandableSectionCard(
        title: mutasi.familyName,
        subtitle: "tanggal: ${mutasi.date}",
        statusChip: StatusChip(
          label: mutasi.mutationType,
          color: mutasi.statusColor,
          icon: _getMutationIcon(mutasi.mutationType),
        ),
        isExpanded: _expandedList[index],
        onToggleExpand: () {
          setState(() {
            _expandedList[index] = !_expandedList[index];
          });
        },
        expandedContent: [
          _buildInfoRow(
            Icons.family_restroom,
            "Nama Keluarga",
            mutasi.familyName,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            "Tanggal Mutasi",
            mutasi.date,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.swap_horiz,
            "Jenis Mutasi",
            mutasi.mutationType,
          ),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: false,
            onDetailPressed: () {
              context.pushNamed(
                'mutasi_keluarga_detail',
                queryParameters: {'index': index.toString()},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getMutationIcon(String type) {
    if (type.toLowerCase().contains('masuk')) {
      return Icons.input;
    } else if (type.toLowerCase().contains('keluar')) {
      return Icons.output;
    } else if (type.toLowerCase().contains('pindah')) {
      return Icons.swap_horiz;
    }
    return Icons.change_circle;
  }
}