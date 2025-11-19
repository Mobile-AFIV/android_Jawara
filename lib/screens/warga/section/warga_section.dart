import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart' as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart' as custom_filter;
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class WargaSection extends StatefulWidget {
  const WargaSection({super.key});

  @override
  State<WargaSection> createState() => _WargaSectionState();
}

class _WargaSectionState extends State<WargaSection> {
  late List<bool> _expandedList;
  final ScrollController _scrollController = ScrollController();

  // Search and filter states
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<WargaModel> _filteredData = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
    _initSearchAndFilter();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      WargaDummy.dummyData.length,
      (index) => index == 0,
    );
  }

  void _initSearchAndFilter() {
    _filteredData = List.from(WargaDummy.dummyData);
    _searchController.addListener(_filterData);
  }

  void _filterData() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredData = WargaDummy.dummyData.where((warga) {
        bool matchesSearch = warga.name.toLowerCase().contains(query) ||
                             warga.nik.contains(query) ||
                             warga.family.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'Semua' ||
                             warga.domicileStatus == _selectedFilter;
        return matchesSearch && matchesFilter;
      }).toList();
      _expandedList = List.generate(_filteredData.length, (index) => index == 0);
    });
  }

  void _showFilterBottomSheet() {
    custom_filter.FilterBottomSheet.show(
      context: context,
      title: 'Filter Status Domisili',
      options: ['Semua', 'Aktif', 'Nonaktif'],
      selectedValue: _selectedFilter,
      onSelected: (filter) {
        setState(() => _selectedFilter = filter);
        _filterData();
      },
      showIcons: true,
      optionIcons: {
        'Semua': Icons.list,
        'Aktif': Icons.check_circle,
        'Nonaktif': Icons.cancel,
      },
    );
  }

  IconData? _getIconForFilter(String filter) {
    switch (filter) {
      case 'Aktif':
        return Icons.check_circle;
      case 'Nonaktif':
        return Icons.cancel;
      default:
        return null;
    }
  }

  @override
  void dispose() {
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
                hintText: 'Cari nama, NIK, atau keluarga...',
                onChanged: (value) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : const Text("Data Warga"),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await context.pushNamed('warga_tambah');

          if (result == true) {
            setState(() {
              _initExpandedList();
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Warga'),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final warga = _filteredData[index];
    final originalIndex = WargaDummy.dummyData.indexOf(warga);
    bool isExpanded = index < _expandedList.length ? _expandedList[index] : false;
    MaterialColor statusColor = warga.domicileStatus == "Aktif" 
        ? Colors.green 
        : Colors.red;
    bool isActive = warga.domicileStatus == "Aktif";

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
        title: warga.name,
        subtitle: "status: ${warga.lifeStatus}",
        statusChip: StatusChip(
          label: warga.domicileStatus,
          color: statusColor,
          icon: isActive ? Icons.check_circle : Icons.cancel,
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
          _buildInfoRow(
            Icons.credit_card,
            "NIK",
            warga.nik,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.family_restroom,
            "Keluarga",
            warga.family,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            warga.gender == "Laki-laki" ? Icons.male : Icons.female,
            "Jenis Kelamin",
            warga.gender,
          ),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: true,
            onEditPressed: () async {
              final result = await context.pushNamed(
                'warga_edit',
                queryParameters: {
                  'index': originalIndex.toString(),
                  'name': warga.name,
                },
              );
              if (result == true) {
                setState(() {
                  if (_expandedList.length != WargaDummy.dummyData.length) {
                    _initExpandedList();
                  }
                });
              }
            },
            onDetailPressed: () {
              context.pushNamed(
                'warga_detail',
                queryParameters: {
                  'index': originalIndex.toString(),
                  'name': warga.name,
                },
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
}