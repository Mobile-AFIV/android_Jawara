import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/warga_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class WargaSection extends StatefulWidget {
  const WargaSection({super.key});

  @override
  State<WargaSection> createState() => _WargaSectionState();
}

class _WargaSectionState extends State<WargaSection> {
  // Track which cards are expanded
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
  }

  // Method to properly initialize or update the expanded list
  void _initExpandedList() {
    _expandedList = List.generate(WargaDummy.dummyData.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Warga"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: WargaDummy.dummyData.length,
        itemBuilder: (context, index) {
          final warga = WargaDummy.dummyData[index];
          return _buildWargaCard(warga, index);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () async {
          // Add await to handle the result when returning from WargaTambah
          final result = await context.pushNamed('warga_tambah');

          // If data was successfully added, refresh the UI
          if (result == true) {
            setState(() {
              // Re-initialize the expanded list to match the updated data
              _initExpandedList();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWargaCard(WargaModel warga, int index) {
    bool isExpanded = index < _expandedList.length ? _expandedList[index] : false;
    MaterialColor statusColor = warga.domicileStatus == "Aktif" ? Colors.green : Colors.red;

    return ExpandableSectionCard(
      title: warga.name,
      subtitle: "status: ${warga.lifeStatus}",
      statusChip: StatusChip(
        label: warga.domicileStatus,
        color: statusColor,
      ),
      isExpanded: isExpanded,
      onToggleExpand: () {
        setState(() {
          // Safety check before modifying the expanded list
          if (index < _expandedList.length) {
            _expandedList[index] = !_expandedList[index];
          }
        });
      },
      expandedContent: [
        // Resident details
        Text("NIK: ${warga.nik}"),
        Text("Keluarga: ${warga.family}"),
        Text("Jenis Kelamin: ${warga.gender}"),
        const SizedBox(height: 16),

        // Action buttons
        SectionActionButtons(
          showEditButton: true,
          onEditPressed: () async {
            final result = await context.pushNamed(
              'warga_edit',
              queryParameters: {
                'index': index.toString(),
                'name': warga.name,
              },
            );
            if (result == true) {
              setState(() {
                // Ensure expanded list matches data after edit
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
                'index': index.toString(),
                'name': warga.name,
              },
            );
          },
        ),
      ],
    );
  }
}