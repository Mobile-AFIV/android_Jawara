import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/warga/section/tambah/rumah_tambah.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahSection extends StatefulWidget {
  const RumahSection({super.key});

  @override
  State<RumahSection> createState() => _RumahSectionState();
}

class _RumahSectionState extends State<RumahSection>
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
      RumahDummy.dummyData.length,
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

  Future<void> _showAddHouseBottomSheet() async {
    await _fabController.reverse();
    
    final result = await ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const RumahTambah(),
      ],
    );

    _fabController.forward();

    if (result == true) {
      setState(() {
        _initExpandedList();
      });
    }
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
        title: const Text("Data Rumah"),
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
          itemCount: RumahDummy.dummyData.length,
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
              onPressed: _showAddHouseBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Rumah'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final rumah = RumahDummy.dummyData[index];
    final bool isExpanded = index < _expandedList.length ? _expandedList[index] : false;
    bool isAvailable = rumah.status.toLowerCase() == 'tersedia';

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
        title: rumah.address.length > 30
            ? "${rumah.address.substring(0, 30)}..."
            : rumah.address,
        statusChip: StatusChip(
          label: rumah.status,
          color: rumah.statusColor,
          icon: _getStatusIcon(rumah.status),
        ),
        isExpanded: isExpanded,
        onToggleExpand: () {
          setState(() {
            if (index < _expandedList.length) {
              _expandedList[index] = !_expandedList[index];
            }
          });
        },
        expandedContent: [
          _buildAddressCard(rumah.address),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: true,
            onEditPressed: isAvailable
                ? () async {
                    final result = await context.pushNamed(
                      'rumah_edit',
                      queryParameters: {
                        'index': index.toString(),
                        'address': rumah.address,
                      },
                    );
                    if (result == true) {
                      setState(() {
                        if (_expandedList.length != RumahDummy.dummyData.length) {
                          _initExpandedList();
                        }
                      });
                    }
                  }
                : () {
                    _showEditNotAvailableSnackbar();
                  },
            onDetailPressed: () {
              context.pushNamed(
                'rumah_detail',
                queryParameters: {
                  'index': index.toString(),
                  'address': rumah.address,
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_on,
              size: 24,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alamat Lengkap",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNotAvailableSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hanya rumah dengan status "Tersedia" yang dapat diedit',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Icons.check_circle;
      case 'terisi':
        return Icons.home;
      case 'tidak tersedia':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}