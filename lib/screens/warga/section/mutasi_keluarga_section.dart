import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart' as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart';
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';

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

  // Search and filter states
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<MutasiKeluargaModel> _filteredData = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
    _initFabAnimation();
    _setupScrollListener();
    _initSearchAndFilter();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      MutasiKeluargaDummy.dummyData.length,
      (index) => index == 0,
    );
  }

  void _initSearchAndFilter() {
    _filteredData = List.from(MutasiKeluargaDummy.dummyData);
    _searchController.addListener(_filterData);
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

  void _filterData() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredData = MutasiKeluargaDummy.dummyData.where((mutasi) {
        bool matchesSearch = mutasi.familyName.toLowerCase().contains(query) ||
                             mutasi.mutationType.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'Semua' ||
                             mutasi.mutationType == _selectedFilter;
        return matchesSearch && matchesFilter;
      }).toList();
      _expandedList = List.generate(_filteredData.length, (index) => index == 0);
    });
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.show(
      context: context,
      title: 'Filter Jenis Mutasi',
      options: ['Semua', ...MutasiKeluargaDummy.mutationTypeOptions],
      selectedValue: _selectedFilter,
      onSelected: (value) {
        setState(() => _selectedFilter = value);
        _filterData();
      },
      showIcons: true,
      optionIcons: {
        'Semua': Icons.list,
        'Pindah Masuk': Icons.login,
        'Keluar Wilayah': Icons.logout,
      },
    );
  }

  IconData? _getIconForFilter(String filter) {
    switch (filter) {
      case 'Pindah Masuk':
        return Icons.login;
      case 'Keluar Wilayah':
        return Icons.logout;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? custom_search.SearchBar(
                controller: _searchController,
                hintText: 'Cari nama keluarga atau jenis mutasi...',
                onChanged: (value) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : const Text("Data Mutasi Keluarga"),
        elevation: 0,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() => _isSearching = true);
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active filter indicator
            ActiveFilterChip(
              activeFilter: _selectedFilter,
              icon: _getIconForFilter(_selectedFilter),
              onClear: () {
                setState(() {
                  _selectedFilter = 'Semua';
                  _filterData();
                });
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() => _initExpandedList());
                  _filterData();
                },
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    return _buildAnimatedCard(index);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
              ),
            ),
          ],
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
    final mutasi = _filteredData[index];
    final originalIndex = MutasiKeluargaDummy.dummyData.indexOf(mutasi);

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
                queryParameters: {'index': originalIndex.toString()},
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