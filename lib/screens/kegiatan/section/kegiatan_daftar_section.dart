import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart'
    as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart'
    as custom_filter;
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';
import 'package:jawara_pintar/services/kegiatan_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/models/kegiatan.dart';

class KegiatanDaftarSection extends StatefulWidget {
  const KegiatanDaftarSection({super.key});

  @override
  State<KegiatanDaftarSection> createState() => _KegiatanDaftarSectionState();
}

class _KegiatanDaftarSectionState extends State<KegiatanDaftarSection>
    with TickerProviderStateMixin {
  late List<bool> _expandedList = [];
  bool _expandedInitialized = false;
  final ScrollController _scrollController = ScrollController();
  List<KegiatanModel> _kegiatanList = [];

  // Search / Filter
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<KegiatanModel> _filteredData = [];
  bool _isSearching = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _fadeController.forward();

    _searchController.addListener(_filterData);
  }

  void _initExpandedList() {
    _expandedList = List.generate(_filteredData.length, (index) => index == 0);
  }

  void _filterData() {
    setState(() {
      final query = _searchController.text.toLowerCase();

      _filteredData = _kegiatanList.where((k) {
        bool matchSearch = k.namaKegiatan.toLowerCase().contains(query) ||
            k.kategori.toLowerCase().contains(query) ||
            k.lokasi.toLowerCase().contains(query);

        bool matchFilter =
            _selectedFilter == 'Semua' || k.kategori == _selectedFilter;

        return matchSearch && matchFilter;
      }).toList();

      _initExpandedList();
    });
  }

  List<String> _getKategoriUnik() {
    final setKategori = <String>{};
    for (var k in _kegiatanList) {
      setKategori.add(k.kategori);
    }
    return setKategori.toList();
  }

  void _showFilterBottomSheet() {
    custom_filter.FilterBottomSheet.show(
      context: context,
      title: 'Filter Kategori',
      options: ['Semua', ..._getKategoriUnik()],
      selectedValue: _selectedFilter,
      onSelected: (v) {
        setState(() {
          _selectedFilter = v;
        });
        _filterData();
      },
      showIcons: true,
      optionIcons: {
        'Semua': Icons.list,
        'Sosial': Icons.volunteer_activism,
        'Pendidikan': Icons.school,
        'Keagamaan': Icons.self_improvement,
        'Lingkungan': Icons.nature,
        'Kesehatan': Icons.health_and_safety,
        'Olahraga': Icons.sports,
        'Pelatihan': Icons.workspace_premium,
        'Rapat': Icons.meeting_room,
        'Lainnya': Icons.more_horiz,
      },
    );
  }

  MaterialColor _getCategoryColor(String kategori) {
    switch (kategori) {
      case 'Sosial':
        return Colors.deepOrange;
      case 'Pendidikan':
        return Colors.indigo;
      case 'Keagamaan':
        return Colors.teal;
      case 'Lingkungan':
        return Colors.green;
      case 'Kesehatan':
        return Colors.red;
      case 'Olahraga':
        return Colors.purple;
      case 'Pelatihan':
        return Colors.blueGrey;
      case 'Rapat':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? custom_search.SearchBar(
                controller: _searchController,
                hintText: 'Cari nama kegiatan, kategori, atau lokasi...',
                onChanged: (_) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filterData();
                  });
                },
              )
            : const Text("Daftar Kegiatan"),
        elevation: 0,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: StreamBuilder<List<KegiatanModel>>(
        stream: KegiatanService.instance.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _kegiatanList = snapshot.data!;
          _filteredData = List.from(_kegiatanList);

          // FIX: Jangan reset expandedList setiap build
          if (!_expandedInitialized) {
            _initExpandedList();
            _expandedInitialized = true;
          }

          return _buildBodyContent();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyles.primaryColor,
        onPressed: () async {
          final result = await context.pushNamed('kegiatan_tambah');
          if (result == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kegiatan'),
      ),
    );
  }

  Widget _buildBodyContent() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _filteredData.length,
      itemBuilder: (context, index) => _buildAnimatedCard(index),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final kegiatan = _filteredData[index];
    final originalIndex = _kegiatanList.indexOf(kegiatan);
    bool isExpanded = _expandedList[index];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0, end: 1),
      builder: (ctx, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: ExpandableSectionCard(
        title: kegiatan.namaKegiatan,
        subtitle: kegiatan.tanggal,
        statusChip: StatusChip(
          label: kegiatan.kategori,
          color: _getCategoryColor(kegiatan.kategori),
          icon: Icons.event,
        ),
        isExpanded: isExpanded,
        onToggleExpand: () {
          setState(() => _expandedList[index] = !isExpanded);
        },
        expandedContent: [
          _buildInfoRow(Icons.category, "Kategori", kegiatan.kategori),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.description, "Deskripsi", kegiatan.deskripsi),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_month, "Tanggal", kegiatan.tanggal),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.place, "Lokasi", kegiatan.lokasi),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.person, "Penanggung Jawab", kegiatan.penanggungJawab),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.account_circle, "Dibuat Oleh", kegiatan.dibuatOleh),
          const SizedBox(height: 12),
          _buildGallery(kegiatan.dokumentasi),
          const SizedBox(height: 12),
          SectionActionButtons(
            showEditButton: true,
            onEditPressed: () async {
              final result = await context.pushNamed(
                'kegiatan_edit',
                queryParameters: {
                  'index': originalIndex.toString(),
                  'title': kegiatan.namaKegiatan,
                },
              );
              if (result == true) {
                setState(() {});
              }
            },
            onDetailPressed: () {
              context.pushNamed(
                'kegiatan_detail',
                queryParameters: {
                  'index': originalIndex.toString(),
                  'title': kegiatan.namaKegiatan,
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
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(List<String> images) {
    if (images.isEmpty) {
      return const Text("Tidak ada dokumentasi",
          style: TextStyle(fontSize: 14, color: Colors.black54));
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final img = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              img,
              width: 140,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 140, height: 96, color: Colors.grey[300]),
            ),
          );
        },
      ),
    );
  }
}
