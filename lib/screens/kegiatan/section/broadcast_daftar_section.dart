import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/kegiatan/section/widget/section_action_button.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart'
    as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart'
    as custom_filter;
import 'package:jawara_pintar/models/broadcast.dart';
import 'package:jawara_pintar/services/broadcast_service.dart';

class BroadcastDaftarSection extends StatefulWidget {
  const BroadcastDaftarSection({super.key});

  @override
  State<BroadcastDaftarSection> createState() => _BroadcastDaftarSectionState();
}

class _BroadcastDaftarSectionState extends State<BroadcastDaftarSection>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<bool> _expandedList;
  bool _expandedInitialized = false;

  String _activeFilter = "Semua";

  List<BroadcastModel> _allData = []; // data dari firebase
  List<BroadcastModel> _filteredData = []; // hasil search/filter
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

    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  // -------------------------------------------------------
  // FIREBASE STREAM
  // -------------------------------------------------------
  Stream<List<BroadcastModel>> getBroadcastStream() {
    return FirebaseFirestore.instance
        .collection("broadcasts")
        .orderBy("tanggal", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BroadcastModel.fromFirestore(doc))
          .toList();
    });
  }

  // -------------------------------------------------------
  // SEARCH
  // -------------------------------------------------------
  void _applySearch(String query) {
    setState(() {
      _filteredData = _allData.where((b) {
        return b.nama.toLowerCase().contains(query.toLowerCase()) ||
            b.isi.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _initExpandedList();
    });
  }

  // -------------------------------------------------------
  // FILTER
  // -------------------------------------------------------
  void _showFilterBottomSheet() {
    custom_filter.FilterBottomSheet.show(
      context: context,
      title: "Filter Broadcast",
      options: const ["Semua", "Dengan Lampiran", "Tanpa Lampiran"],
      selectedValue: _activeFilter,
      onSelected: (value) {
        setState(() {
          _activeFilter = value;
        });
      },
    );
  }

  // -------------------------------------------------------
  // EXPAND INIT
  // -------------------------------------------------------
  void _initExpandedList() {
    // Memastikan ukuran list sesuai dengan _filteredData yang baru
    _expandedList = List.generate(_filteredData.length, (i) => i == 0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? custom_search.SearchBar(
                controller: _searchController,
                hintText: "Cari broadcast...",
                onChanged: (_) => _applySearch(_searchController.text),
                onClear: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filteredData = List.from(_allData);
                  });
                  _initExpandedList();
                },
              )
            : const Text("Broadcast Kegiatan"),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterBottomSheet,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kegiatan'),
        onPressed: () async {
          final result = await context.pushNamed("broadcast_tambah");

          if (result != null) {
            // Memaksa rebuild setelah kembali dari Tambah
            setState(() {});
          }
        },
      ),
      body: StreamBuilder<List<BroadcastModel>>(
        stream: getBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Perbaikan Null Safety dan Empty Data
          final List<BroadcastModel>? fetchedData = snapshot.data;

          if (!snapshot.hasData || fetchedData == null || fetchedData.isEmpty) {
            return const Center(child: Text("Belum ada broadcast"));
          }

          _allData = fetchedData;

          final oldFilteredLength = _filteredData.length;

          // Re-apply filter/search logic
          if (!_isSearching && _activeFilter == "Semua") {
            _filteredData = List.from(_allData);
          } else {
            // Jika sedang search/filter aktif, pastikan _filteredData diperbarui
            // dengan data terbaru dari _allData sebelum memanggil _applySearch atau _applyFilterLogic
            // Namun, karena _applySearch/Logic sudah memanggil setState, kita perlu sedikit modifikasi
            // agar logika filtering dilakukan di sini jika terjadi perubahan data.

            // Cek apakah ada perubahan data di stream (biasanya ini sudah cukup)
            if (_filteredData.length != _allData.length &&
                !_isSearching &&
                _activeFilter == "Semua") {
              _filteredData = List.from(_allData);
            }
          }

          // Perbarui _expandedList hanya jika panjang list berubah
          if (!_expandedInitialized ||
              _filteredData.length != oldFilteredLength) {
            _initExpandedList();
            _expandedInitialized = true;
          }

          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _filteredData.length,
      itemBuilder: (context, index) => _buildAnimatedCard(index),
    );
  }

  // -------------------------------------------------------
  // CARD
  // -------------------------------------------------------
  Widget _buildAnimatedCard(int index) {
    final item = _filteredData[index];

    return StatefulBuilder(builder: (context, setState) {
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
          title: item.nama,
          subtitle: "Publikasi: ${item.tanggal}",
          statusChip: StatusChip(
            label: "Broadcast",
            color: Colors.deepPurple,
            icon: Icons.campaign,
          ),
          isExpanded: isExpanded,
          onToggleExpand: () {
            setState(() => _expandedList[index] = !isExpanded);
          },
          expandedContent: [
            // Menggunakan _buildInfoRow sebagai pengganti _buildDetail
            _buildInfoRow(Icons.subject, "Isi Broadcast", item.isi),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_month, "Tanggal", item.tanggal),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.account_circle, "Dibuat Oleh", item.dibuatOleh),

            const SizedBox(height: 12),
            SectionActionButton(
              showDeleteButton: true,
              onEditPressed: () {
                context.pushNamed(
                  "broadcast_edit",
                  // Menggunakan pathParameters, bukan extra
                  pathParameters: {'broadcastId': item.id},
                  queryParameters: {'title': item.nama},
                );
              },
              onDeletePressed: () => _confirmDelete(item),
            ),
          ],
        ),
      );
    });
  }

  // -------------------------------------------------------
  // WIDGET BARU (Menggantikan _buildDetail)
  // -------------------------------------------------------
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Penting agar icon dan teks sejajar di atas
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

  void _confirmDelete(BroadcastModel broadcast) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Broadcast'),
        content: Text(
          'Apakah kamu yakin ingin menghapus broadcast "${broadcast.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);

              await BroadcastService.instance.deleteBroadcast(broadcast.id);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broadcast berhasil dihapus'),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
