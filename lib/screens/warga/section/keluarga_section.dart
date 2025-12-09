import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart'
    as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart';
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';

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
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isSearching = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initScrollButton();
    _setupScrollListener();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get all warga data from Firebase
      final snapshot = await FirebaseFirestore.instance
          .collection('warga')
          .orderBy('createdAt', descending: true)
          .get();

      // Group warga by family name
      Map<String, Map<String, dynamic>> familyMap = {};

      for (var doc in snapshot.docs) {
        final warga = doc.data();
        final familyName = warga['family'] ?? 'Tidak Diketahui';

        if (!familyMap.containsKey(familyName)) {
          // Create new family entry
          familyMap[familyName] = {
            'id': familyName, // Use family name as ID
            'familyName': familyName,
            'headOfFamily': '',
            'address': '',
            'ownershipStatus': 'Milik Sendiri',
            'status': 'Aktif',
            'members': [],
            'memberCount': 0,
          };
        }

        // Add member to family
        familyMap[familyName]!['members'].add({
          'name': warga['name'] ?? '',
          'role': warga['familyRole'] ?? '',
          'status': warga['lifeStatus'] ?? 'Hidup',
          'birthDate': warga['birthDate'] ?? '',
          'gender': warga['gender'] ?? '',
        });

        // Set head of family
        if (warga['familyRole'] == 'Kepala Keluarga') {
          familyMap[familyName]!['headOfFamily'] = warga['name'] ?? '';
        }

        // Update member count
        familyMap[familyName]!['memberCount'] =
            (familyMap[familyName]!['members'] as List).length;
      }

      // Get address from rumah_warga collection if available
      final rumahSnapshot =
          await FirebaseFirestore.instance.collection('rumah_warga').get();

      for (var rumahDoc in rumahSnapshot.docs) {
        final rumahData = rumahDoc.data();
        // You can implement logic to link rumah to keluarga here
        // For now, we'll use the first available address
      }

      setState(() {
        _allData = familyMap.values.toList();
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
      List<Map<String, dynamic>> tempData = _allData;

      // Filter by status
      if (_selectedFilter != 'Semua') {
        tempData = tempData.where((keluarga) {
          return keluarga['status'] == _selectedFilter;
        }).toList();
      }

      // Filter by search
      if (_searchController.text.isNotEmpty) {
        final searchQuery = _searchController.text.toLowerCase();
        tempData = tempData.where((keluarga) {
          final familyName = (keluarga['familyName'] ?? '').toLowerCase();
          final headOfFamily = (keluarga['headOfFamily'] ?? '').toLowerCase();
          return familyName.contains(searchQuery) ||
              headOfFamily.contains(searchQuery);
        }).toList();
      }

      _filteredData = tempData;
      _expandedList =
          List.generate(_filteredData.length, (index) => index == 0);
    });
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.show(
      context: context,
      title: 'Filter Status Keluarga',
      options: ['Semua', 'Aktif', 'Nonaktif'],
      selectedValue: _selectedFilter,
      onSelected: (value) {
        setState(() => _selectedFilter = value);
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
                              Icon(Icons.family_restroom,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada data keluarga',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            RefreshIndicator(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final keluarga = _filteredData[index];
    bool isExpanded =
        index < _expandedList.length ? _expandedList[index] : false;
    String status = keluarga['status'] ?? 'Aktif';
    MaterialColor statusColor = status == 'Aktif' ? Colors.green : Colors.red;

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
        title: keluarga['familyName'] ?? '',
        subtitle: "kepala: ${keluarga['headOfFamily'] ?? ''}",
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
          _buildInfoRow(
            Icons.family_restroom,
            "Nama Keluarga",
            keluarga['familyName'] ?? '',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.person,
            "Kepala Keluarga",
            keluarga['headOfFamily'] ?? '',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.location_on,
            "Alamat",
            keluarga['address'] ?? '',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.home,
            "Status Kepemilikan",
            keluarga['ownershipStatus'] ?? '',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.group,
            "Jumlah Anggota",
            "${keluarga['memberCount'] ?? 0} orang",
          ),
          const SizedBox(height: 16),
          SectionActionButtons(
            showEditButton: false,
            onDetailPressed: () {
              context.pushNamed(
                'keluarga_detail',
                queryParameters: {'id': keluarga['id']?.toString() ?? ''},
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
