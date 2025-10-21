import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';

class KeluargaSection extends StatefulWidget {
  const KeluargaSection({super.key});

  @override
  State<KeluargaSection> createState() => _KeluargaSectionState();
}

class _KeluargaSectionState extends State<KeluargaSection> {
  // Track which cards are expanded
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _expandedList = List.generate(KeluargaDummy.dummyData.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Keluarga"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: KeluargaDummy.dummyData.length,
        itemBuilder: (context, index) {
          final keluarga = KeluargaDummy.dummyData[index];
          return _buildFamilyCard(keluarga, index);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }

  Widget _buildFamilyCard(KeluargaModel keluarga, int index) {
    return ExpandableSectionCard(
      title: keluarga.familyName,
      subtitle: "kepala: ${keluarga.headOfFamily}",
      statusChip: StatusChip(
        label: keluarga.status,
        color: keluarga.statusColor,
      ),
      isExpanded: _expandedList[index],
      onToggleExpand: () {
        setState(() {
          _expandedList[index] = !_expandedList[index];
        });
      },
      expandedContent: [
        // Family details
        Text("Nama Keluarga: ${keluarga.familyName}"),
        Text("Kepala Keluarga: ${keluarga.headOfFamily}"),
        Text("Alamat: ${keluarga.address}"),
        Text("Status Kepemilikan: ${keluarga.ownershipStatus}"),
        const SizedBox(height: 8),

        // Action buttons
        const SizedBox(height: 8),
        SectionActionButtons(
          showEditButton: false,
          onDetailPressed: () {
            context.pushNamed(
              'keluarga_detail',
              queryParameters: {'index': index.toString()},
            );
          },
        ),
      ],
    );
  }
}