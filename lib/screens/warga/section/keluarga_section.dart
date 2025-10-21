import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart' as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart';

class KeluargaSection extends StatefulWidget {
  const KeluargaSection({super.key});

  @override
  State<KeluargaSection> createState() => _KeluargaSectionState();
}

class _KeluargaSectionState extends State<KeluargaSection>
    with TickerProviderStateMixin {
  late List<bool> _expandedList;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  late AnimationController _scrollButtonController;
  late Animation<double> _scrollButtonAnimation;

  // Search and filter states
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<KeluargaModel> _filteredData = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
    _initScrollButton();
    _setupScrollListener();
    _initSearchAndFilter();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      KeluargaDummy.dummyData.length,
      (index) => index == 0,
    );
  }

  void _initSearchAndFilter() {
    _filteredData = List.from(KeluargaDummy.dummyData);
    _searchController.addListener(_filterData);
  }

  void _initScrollButton() {
    _scrollButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollButtonAnimation = CurvedAnimation(
      parent: _scrollButtonController,
      curve: Curves.easeInOut,
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
        _scrollButtonController.forward();
      } else if (_scrollController.offset <= 200 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
        _scrollButtonController.reverse();
      }
    });
  }

  void _filterData() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredData = KeluargaDummy.dummyData.where((keluarga) {
        bool matchesSearch = keluarga.familyName.toLowerCase().contains(query) ||
                             keluarga.headOfFamily.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'Semua' ||
                             keluarga.status == _selectedFilter;
        return matchesSearch && matchesFilter;
      }).toList();
      _expandedList = List.generate(_filteredData.length, (index) => index == 0);
    });
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.show(
      context: context,
      title: 'Filter Status',
      options: ['Semua', 'Aktif', 'Nonaktif'],
      selectedValue: _selectedFilter,
      onSelected: (value) {
        setState(() => _selectedFilter = value);
        _filterData();
      },
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollButtonController.dispose();
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
                hintText: 'Cari nama keluarga atau kepala keluarga...',
                onChanged: (value) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : const Text("Data Keluarga"),
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                _initExpandedList();
                _filterData();
              });
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
          
          // Scroll to top button
          Positioned(
            right: 16,
            bottom: 16,
            child: ScaleTransition(
              scale: _scrollButtonAnimation,
              child: FloatingActionButton.small(
                heroTag: 'scrollToTop',
                onPressed: _scrollToTop,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final keluarga = _filteredData[index];
    final originalIndex = KeluargaDummy.dummyData.indexOf(keluarga);

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
        title: keluarga.familyName,
        subtitle: "kepala: ${keluarga.headOfFamily}",
        statusChip: StatusChip(
          label: keluarga.status,
          color: keluarga.statusColor,
          icon: _getStatusIcon(keluarga.status),
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
            keluarga.familyName,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.person,
            "Kepala Keluarga",
            keluarga.headOfFamily,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.location_on,
            "Alamat",
            keluarga.address,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.home,
            "Status Kepemilikan",
            keluarga.ownershipStatus,
          ),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: false,
            onDetailPressed: () {
              context.pushNamed(
                'keluarga_detail',
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Icons.check_circle;
      case 'nonaktif':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}