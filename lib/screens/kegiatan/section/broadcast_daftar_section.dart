import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==== IMPORT WIDGET CUSTOM YANG SUDAH ADA DI KEGIATAN ====
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/screens/warga/section/widget/active_filter_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/custom_filter_sheet.dart';

// ==========================================================
//                     MODEL BROADCAST
// ==========================================================
class BroadcastModel {
  final String nama;
  final String isi;
  final String tanggal;
  final String dibuatOleh;
  final List<String> lampiranGambar;
  final List<String> lampiranPdf;

  BroadcastModel({
    required this.nama,
    required this.isi,
    required this.tanggal,
    required this.dibuatOleh,
    this.lampiranGambar = const [],
    this.lampiranPdf = const [],
  });
}

// ==========================================================
//                     HALAMAN DAFTAR BROADCAST
// ==========================================================
class BroadcastDaftarSection extends StatefulWidget {
  const BroadcastDaftarSection({super.key});

  @override
  State<BroadcastDaftarSection> createState() => _BroadcastDaftarSectionState();
}

class _BroadcastDaftarSectionState extends State<BroadcastDaftarSection> {
  final TextEditingController searchController = TextEditingController();

  // Dummy data — nanti ganti API kamu
  List<BroadcastModel> data = [
    BroadcastModel(
      nama: "Pengumuman Kerja Bakti",
      isi: "Kerja bakti akan dilakukan pada Minggu pukul 07:00 WIB.",
      tanggal: "2025-11-20",
      dibuatOleh: "Pak RT",
      lampiranGambar: ["https://via.placeholder.com/200"],
      lampiranPdf: ["jadwal_kegiatan.pdf"],
    ),
    BroadcastModel(
      nama: "Rapat Warga",
      isi: "Rapat warga wajib untuk seluruh kepala keluarga.",
      tanggal: "2025-11-18",
      dibuatOleh: "RW 02",
    ),
  ];

  List<BroadcastModel> filteredData = [];
  List<String> activeFilters = [];

  // Map untuk menyimpan state expand per index
  Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    filteredData = data;
  }

  // ==========================================================
  //                           SEARCH
  // ==========================================================
  void _applySearch(String query) {
    setState(() {
      filteredData = data.where((b) {
        return b.nama.toLowerCase().contains(query.toLowerCase()) ||
            b.isi.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // ==========================================================
  //                           FILTER
  // ==========================================================
  void _openFilter() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CustomFilterSheet(
          availableFilters: const ["Dengan Lampiran", "Tanpa Lampiran"],
          selectedFilters: activeFilters,
        );
      },
    );

    if (result != null) {
      setState(() {
        activeFilters = result;
        _applyFilterLogic();
      });
    }
  }

  void _applyFilterLogic() {
    filteredData = data.where((b) {
      bool withAttachment =
          b.lampiranGambar.isNotEmpty || b.lampiranPdf.isNotEmpty;
      if (activeFilters.contains("Dengan Lampiran") && !withAttachment)
        return false;
      if (activeFilters.contains("Tanpa Lampiran") && withAttachment)
        return false;
      return true;
    }).toList();
  }

  // ==========================================================
  //                           UI
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Broadcast Kegiatan"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed("broadcast_tambah"),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // === Search bar ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: SearchBar(
              controller: searchController,
              hintText: "Cari broadcast...",
              onChanged: _applySearch,
            ),
          ),

          // === Active Filters ===
          if (activeFilters.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: activeFilters.map((f) {
                  return ActiveFilterChip(
                    activeFilter: f,
                    onClear: () {
                      setState(() {
                        activeFilters.remove(f);
                        _applyFilterLogic();
                      });
                    },
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 8),

          // === Broadcast List ===
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredData.length,
              itemBuilder: (context, i) {
                final item = filteredData[i];
                final isExpanded = expandedMap[i] ?? false;

                return ExpandableSectionCard(
                  title: item.nama,
                  subtitle: "Publikasi: ${item.tanggal}",
                  statusChip: StatusChip(
                    label: "Broadcast",
                    color: Colors.deepPurple,
                  ),
                  isExpanded: isExpanded,
                  onToggleExpand: () {
                    setState(() {
                      expandedMap[i] = !isExpanded;
                    });
                  },
                  expandedContent: [
                    _buildDetailText("Isi Broadcast", item.isi),
                    _buildDetailText("Dibuat Oleh", item.dibuatOleh),
                    if (item.lampiranGambar.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text("Lampiran Gambar:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildImageGrid(item.lampiranGambar),
                    ],
                    if (item.lampiranPdf.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text("Lampiran PDF:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildPdfList(item.lampiranPdf),
                    ],
                    const SizedBox(height: 12),
                    SectionActionButtons(
                      onDetailPressed: () =>
                          context.pushNamed("broadcast_detail"),
                      onEditPressed: () => context.pushNamed("broadcast_edit"),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  //                      BUILD DETAIL ITEM
  // ==========================================================
  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  // ==========================================================
  //                      GRID LAMPIRAN GAMBAR
  // ==========================================================
  Widget _buildImageGrid(List<String> images) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: images
          .map((url) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(url, fit: BoxFit.cover),
              ))
          .toList(),
    );
  }

  // ==========================================================
  //                      LIST LAMPIRAN PDF
  // ==========================================================
  Widget _buildPdfList(List<String> pdfs) {
    return Column(
      children: pdfs
          .map((pdf) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(pdf),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                ),
              ))
          .toList(),
    );
  }
}
