import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart' as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart' as custom_filter;
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

/// ---------------------------
/// Model & Dummy (Kegiatan)
/// ---------------------------
class KegiatanModel {
  final String namaKegiatan;
  final String kategori;
  final String deskripsi;
  final String tanggal;
  final String lokasi;
  final String penanggungJawab;
  final String dibuatOleh;
  final List<String> dokumentasi;

  KegiatanModel({
    required this.namaKegiatan,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.penanggungJawab,
    required this.dibuatOleh,
    this.dokumentasi = const [],
  });
}

class KegiatanDummy {
  static final List<String> kategoriOptions = [
    "Sosial",
    "Pendidikan",
    "Keagamaan",
    "Lingkungan",
    "Kesehatan",
    "Olahraga",
    "Pelatihan",
    "Rapat",
    "Lainnya",
  ];

  static List<KegiatanModel> dummyKegiatan = [
    KegiatanModel(
      namaKegiatan: "Kerja Bakti Bersih Lingkungan",
      kategori: "Lingkungan",
      deskripsi:
          "Membersihkan area sekitar RT termasuk selokan, taman, dan jalan umum. Semua warga diharapkan membawa alat sederhana seperti sapu dan cangkul.",
      tanggal: "12 Oktober 2025",
      lokasi: "Area RT 05 RW 03",
      penanggungJawab: "Budi Santoso",
      dibuatOleh: "Ketua RT",
      dokumentasi: [
        "https://via.placeholder.com/400x300.png?text=kerjabakti+1",
        "https://via.placeholder.com/400x300.png?text=kerjabakti+2",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Pengajian Rutin Bulanan",
      kategori: "Keagamaan",
      deskripsi:
          "Pengajian rutin bersama warga untuk meningkatkan wawasan spiritual dan kebersamaan antarwarga.",
      tanggal: "05 Oktober 2025",
      lokasi: "Musholla Al-Ikhlas",
      penanggungJawab: "Ahmad Fauzi",
      dibuatOleh: "Seksi Keagamaan",
      dokumentasi: [
        "https://via.placeholder.com/400x300.png?text=pengajian+1",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Senam Pagi Mingguan",
      kategori: "Olahraga",
      deskripsi:
          "Senam pagi setiap minggu untuk meningkatkan kesehatan warga dan menumbuhkan kebiasaan olahraga.",
      tanggal: "28 September 2025",
      lokasi: "Lapangan RT 05",
      penanggungJawab: "Dewi Lestari",
      dibuatOleh: "Seksi Kesehatan",
      dokumentasi: [
        "https://via.placeholder.com/400x300.png?text=senam+1",
        "https://via.placeholder.com/400x300.png?text=senam+2",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Pelatihan Pemanfaatan Limbah Rumah Tangga",
      kategori: "Pendidikan",
      deskripsi:
          "Pelatihan membuat kerajinan dari limbah rumah tangga seperti botol, plastik, dan kertas agar bernilai ekonomis.",
      tanggal: "20 November 2025",
      lokasi: "Balai Warga RT 05",
      penanggungJawab: "Rina Wijaya",
      dibuatOleh: "Seksi Pendidikan",
      dokumentasi: [
        "https://via.placeholder.com/400x300.png?text=pelatihan+1",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Rapat Koordinasi Persiapan HUT RI",
      kategori: "Rapat",
      deskripsi:
          "Rapat untuk membahas persiapan kegiatan perayaan Hari Kemerdekaan RI, pembagian tugas panitia, dan logistik.",
      tanggal: "01 Agustus 2025",
      lokasi: "Rumah Ketua RT",
      penanggungJawab: "Dimas Prasetyo",
      dibuatOleh: "Panitia HUT RI",
      dokumentasi: [],
    ),
  ];
}

/// ---------------------------
/// KegiatanDaftarSection Widget
/// ---------------------------
class KegiatanDaftarSection extends StatefulWidget {
  const KegiatanDaftarSection({super.key});

  @override
  State<KegiatanDaftarSection> createState() => _KegiatanDaftarSectionState();
}

class _KegiatanDaftarSectionState extends State<KegiatanDaftarSection>
    with TickerProviderStateMixin {
  late List<bool> _expandedList;
  final ScrollController _scrollController = ScrollController();

  // Search and filter states
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
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    _initExpandedList();
    _initSearchAndFilter();
  }

  void _initExpandedList() {
    _expandedList = List.generate(
      KegiatanDummy.dummyKegiatan.length,
      (index) => index == 0,
    );
  }

  void _initSearchAndFilter() {
    _filteredData = List.from(KegiatanDummy.dummyKegiatan);
    _searchController.addListener(_filterData);
  }

  void _filterData() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredData = KegiatanDummy.dummyKegiatan.where((kegiatan) {
        bool matchesSearch = kegiatan.namaKegiatan.toLowerCase().contains(query) ||
            kegiatan.kategori.toLowerCase().contains(query) ||
            kegiatan.lokasi.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'Semua' || kegiatan.kategori == _selectedFilter;
        return matchesSearch && matchesFilter;
      }).toList();

      _expandedList = List.generate(_filteredData.length, (index) => index == 0);
    });
  }

  void _showFilterBottomSheet() {
    custom_filter.FilterBottomSheet.show(
      context: context,
      title: 'Filter Kategori Kegiatan',
      options: ['Semua', ...KegiatanDummy.kategoriOptions],
      selectedValue: _selectedFilter,
      onSelected: (filter) {
        setState(() => _selectedFilter = filter);
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

  IconData? _getIconForFilter(String filter) {
    switch (filter) {
      case 'Sosial':
        return Icons.volunteer_activism;
      case 'Pendidikan':
        return Icons.school;
      case 'Keagamaan':
        return Icons.self_improvement;
      case 'Lingkungan':
        return Icons.nature;
      case 'Kesehatan':
        return Icons.health_and_safety;
      case 'Olahraga':
        return Icons.sports;
      case 'Pelatihan':
        return Icons.workspace_premium;
      case 'Rapat':
        return Icons.meeting_room;
      default:
        return null;
    }
  }

  Color _getCategoryColor(String kategori) {
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
        return Colors.redAccent;
      case 'Olahraga':
        return Colors.purple;
      case 'Pelatihan':
        return Colors.blueGrey;
      case 'Rapat':
        return Colors.brown;
      default:
        return AppStyles.primaryColor.withValues(alpha: 1);
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
                onChanged: (value) => _filterData(),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
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
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
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
                    itemBuilder: (context, index) => _buildAnimatedCard(index),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await context.pushNamed('kegiatan_tambah');
          if (result == true) {
            setState(() {
              _initExpandedList();
              _filterData();
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kegiatan'),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final kegiatan = _filteredData[index];
    final originalIndex = KegiatanDummy.dummyKegiatan.indexOf(kegiatan);
    bool isExpanded = index < _expandedList.length ? _expandedList[index] : false;
    final categoryColor = _getCategoryColor(kegiatan.kategori);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
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
          color: categoryColor as MaterialColor? ?? Colors.blue as MaterialColor,
          icon: Icons.event,
        ),
        isExpanded: isExpanded,
        onToggleExpand: () {
          setState(() {
            if (index < _expandedList.length) _expandedList[index] = !_expandedList[index];
          });
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
          _buildInfoRow(Icons.person, "Penanggung Jawab", kegiatan.penanggungJawab),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.account_circle, "Dibuat Oleh", kegiatan.dibuatOleh),
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
                setState(() {
                  _initExpandedList();
                  _filterData();
                });
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

  Widget _buildGallery(List<String> images) {
    if (images.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Text(
          "Tidak ada dokumentasi",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      );
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        padding: const EdgeInsets.only(left: 4),
        itemBuilder: (context, index) {
          final img = images[index];
          return GestureDetector(
            onTap: () {
              // Optional: buka viewer gambar besar atau route detail gambar
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.network(img, fit: BoxFit.contain),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                img,
                width: 140,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  height: 96,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}
