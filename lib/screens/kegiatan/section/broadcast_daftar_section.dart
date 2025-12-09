import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widgets custom
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/search_bar.dart'
    as custom_search;
import 'package:jawara_pintar/screens/warga/section/widget/filter_bottom_sheet.dart'
    as custom_filter;
import 'package:jawara_pintar/models/broadcast.dart';

// -------------------------------------------------------
// HALAMAN DAFTAR BROADCAST (Firebase Version)
// -------------------------------------------------------
class BroadcastDaftarSection extends StatefulWidget {
  const BroadcastDaftarSection({super.key});

  @override
  State<BroadcastDaftarSection> createState() =>
      _BroadcastDaftarSectionState();
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
          _applyFilterLogic();
        });
      },
    );
  }

  void _applyFilterLogic() {
    setState(() {
      _filteredData = _allData.where((b) {
        bool hasAttachment =
            b.lampiranGambar.isNotEmpty || b.lampiranPdf.isNotEmpty;

        if (_activeFilter == "Dengan Lampiran" && !hasAttachment) return false;
        if (_activeFilter == "Tanpa Lampiran" && hasAttachment) return false;

        return true;
      }).toList();

      _initExpandedList();
    });
  }

  // -------------------------------------------------------
  // EXPAND INIT
  // -------------------------------------------------------
  void _initExpandedList() {
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await context.pushNamed("broadcast_tambah");

          if (result != null && result is BroadcastModel) {
            // otomatis muncul karena Firestore stream
          }
        },
      ),

      body: StreamBuilder<List<BroadcastModel>>(
        stream: getBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada broadcast"));
          }

          _allData = snapshot.data!;
          _filteredData = _isSearching || _activeFilter != "Semua"
              ? _filteredData
              : List.from(_allData);

          if (!_expandedInitialized) {
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
      itemBuilder: (context, index) {
        return _buildAnimatedCard(index);
      },
    );
  }

  // -------------------------------------------------------
  // CARD
  // -------------------------------------------------------
  Widget _buildAnimatedCard(int index) {
    final item = _filteredData[index];
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
          _buildDetail("Isi Broadcast", item.isi),
          _buildDetail("Dibuat Oleh", item.dibuatOleh),

          if (item.lampiranGambar.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text("Lampiran Gambar",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildImageGrid(item.lampiranGambar),
          ],

          if (item.lampiranPdf.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text("Lampiran PDF",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPdfList(item.lampiranPdf),
          ],

          const SizedBox(height: 12),
         SectionActionButtons(
  onDetailPressed: () {
    context.pushNamed(
      "broadcast_detail",
      extra: {'id': item.id},
    );
  },
  onEditPressed: () {
    context.pushNamed(
      "broadcast_edit",
      extra: {'id': item.id},
    );
  },
),

        ],
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: images
          .map((url) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(url, fit: BoxFit.cover),
              ))
          .toList(),
    );
  }

  Widget _buildPdfList(List<String> pdfs) {
    return Column(
      children: pdfs
          .map(
            (pdf) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 26),
              title: Text(pdf),
              trailing: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {},
              ),
            ),
          )
          .toList(),
    );
  }
}
