import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/screens/warga/section/tambah/rumah_tambah.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart'
    as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart';
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';

class RumahSection extends StatefulWidget {
  const RumahSection({super.key});

  @override
  State<RumahSection> createState() => _RumahSectionState();
}

class _RumahSectionState extends State<RumahSection> {
  late List<bool> _expandedList;
  final ScrollController _scrollController = ScrollController();

  // Search and filter states
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<Map<String, dynamic>> _filteredData = [];
  bool _isSearching = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rumah')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _filteredData = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _filterData();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  void _filterData() {
    setState(() {
      List<Map<String, dynamic>> tempData = [];

      // Load all data from collection
      FirebaseFirestore.instance
          .collection('rumah')
          .orderBy('createdAt', descending: true)
          .get()
          .then((snapshot) {
        tempData = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        // Filter by status
        if (_selectedFilter != 'Semua') {
          tempData = tempData.where((rumah) {
            return rumah['status'] == _selectedFilter;
          }).toList();
        }

        // Filter by search
        if (_searchController.text.isNotEmpty) {
          final searchQuery = _searchController.text.toLowerCase();
          tempData = tempData.where((rumah) {
            final address = (rumah['address'] ?? '').toLowerCase();
            return address.contains(searchQuery);
          }).toList();
        }

        setState(() {
          _filteredData = tempData;
          _expandedList =
              List.generate(_filteredData.length, (index) => index == 0);
        });
      });
    });
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.show(
      context: context,
      title: 'Filter Status Rumah',
      options: ['Semua', 'Tersedia', 'Ditempati'],
      selectedValue: _selectedFilter,
      onSelected: (value) {
        setState(() => _selectedFilter = value);
        _filterData();
      },
      showIcons: true,
      optionIcons: {
        'Semua': Icons.list,
        'Tersedia': Icons.check_circle,
        'Ditempati': Icons.home,
      },
    );
  }

  Future<void> _showAddHouseBottomSheet() async {
    final result = await ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (setModalState) => [
        const RumahTambah(),
      ],
    );

    if (result == true) {
      _loadData();
    }
  }

  IconData? _getIconForFilter(String filter) {
    switch (filter) {
      case 'Tersedia':
        return Icons.check_circle;
      case 'Ditempati':
        return Icons.home;
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
                hintText: 'Cari alamat rumah...',
                onChanged: (value) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : const Text("Data Rumah"),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_outlined,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada data rumah',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            _loadData();
                          },
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16.0),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _filteredData.length,
                            itemBuilder: (context, index) {
                              return _buildAnimatedCard(index);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: _showAddHouseBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Rumah'),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final rumah = _filteredData[index];
    final bool isExpanded =
        index < _expandedList.length ? _expandedList[index] : false;
    String status = rumah['status'] ?? 'Tersedia';
    String address = rumah['address'] ?? '';
    bool isAvailable = status.toLowerCase() == 'tersedia';
    MaterialColor statusColor = isAvailable ? Colors.green : Colors.blue;

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
        title: address.length > 30 ? "${address.substring(0, 30)}..." : address,
        statusChip: StatusChip(
          label: status,
          color: statusColor,
          icon: _getStatusIcon(status),
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
          _buildAddressCard(address),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: true,
            onEditPressed: isAvailable
                ? () async {
                    final result = await context.pushNamed(
                      'rumah_edit',
                      queryParameters: {
                        'id': rumah['id']?.toString() ?? '',
                        'address': address,
                      },
                    );
                    if (result == true) {
                      _loadData();
                    }
                  }
                : () {
                    _showEditNotAvailableSnackbar();
                  },
            onDetailPressed: () {
              context.pushNamed(
                'rumah_detail',
                queryParameters: {
                  'id': rumah['id']?.toString() ?? '',
                  'address': address,
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
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
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
      case 'ditempati':
        return Icons.home;
      default:
        return Icons.info;
    }
  }
}
