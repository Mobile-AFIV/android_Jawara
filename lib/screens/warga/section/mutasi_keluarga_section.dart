import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/mutasi_keluarga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class MutasiKeluargaSection extends StatefulWidget {
  const MutasiKeluargaSection({super.key});

  @override
  State<MutasiKeluargaSection> createState() => _MutasiKeluargaSectionState();
}

class _MutasiKeluargaSectionState extends State<MutasiKeluargaSection> {
  // Track which cards are expanded
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _expandedList = List.generate(MutasiKeluargaDummy.dummyData.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mutasi Keluarga"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: MutasiKeluargaDummy.dummyData.length,
        itemBuilder: (context, index) {
          final mutasi = MutasiKeluargaDummy.dummyData[index];
          return _buildMutationCard(mutasi, index);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await context.pushNamed('mutasi_keluarga_tambah');
          if (result == true) {
            setState(() {
              _expandedList = List.generate(MutasiKeluargaDummy.dummyData.length, (index) => index == 0);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMutationCard(MutasiKeluargaModel mutasi, int index) {
    return ExpandableSectionCard(
      title: mutasi.familyName,
      subtitle: "tanggal: ${mutasi.date}",
      statusChip: StatusChip(
        label: mutasi.mutationType,
        color: mutasi.statusColor,
      ),
      isExpanded: _expandedList[index],
      onToggleExpand: () {
        setState(() {
          _expandedList[index] = !_expandedList[index];
        });
      },
      expandedContent: [
        // Mutation details
        Text("Nama Keluarga: ${mutasi.familyName}"),
        Text("Tanggal Mutasi: ${mutasi.date}"),
        Text("Jenis Mutasi: ${mutasi.mutationType}"),
        const SizedBox(height: 8),

        // Action buttons
        SectionActionButtons(
          showEditButton: false,
          onDetailPressed: () {
            context.pushNamed(
              'mutasi_keluarga_detail',
              queryParameters: {'index': index.toString()},
            );
          },
        ),
      ],
    );
  }
}