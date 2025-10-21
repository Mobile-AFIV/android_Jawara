import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/expandable_section_card.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_chip.dart';
import 'package:jawara_pintar/screens/warga/section/widget/section_action_buttons.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahSection extends StatefulWidget {
  const RumahSection({super.key});

  @override
  State<RumahSection> createState() => _RumahSectionState();
}

class _RumahSectionState extends State<RumahSection> {
  // Track which cards are expanded
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _initExpandedList();
  }

  // Create a separate method to initialize or update the expanded list
  void _initExpandedList() {
    _expandedList = List.generate(RumahDummy.dummyData.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Rumah"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: RumahDummy.dummyData.length,
        itemBuilder: (context, index) {
          final rumah = RumahDummy.dummyData[index];
          return _buildHouseCard(rumah, index);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await context.pushNamed('rumah_tambah');
          if (result == true) {
            setState(() {
              // Update the expanded list to match the new data size
              _initExpandedList();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHouseCard(RumahModel rumah, int index) {
    final bool isExpanded = index < _expandedList.length ? _expandedList[index] : false;

    return ExpandableSectionCard(
      title: rumah.address.length > 30 ? "${rumah.address.substring(0, 30)}..." : rumah.address,
      statusChip: StatusChip(
        label: rumah.status,
        color: rumah.statusColor,
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
        // House details
        const Text("Alamat Lengkap:"),
        Text(rumah.address),
        const SizedBox(height: 16),

        // Action buttons
        SectionActionButtons(
          showEditButton: true,
          onEditPressed: rumah.status == 'Tersedia' ? () async {
            final result = await context.pushNamed(
              'rumah_edit',
              queryParameters: {
                'index': index.toString(),
                'address': rumah.address,
              },
            );
            if (result == true) {
              setState(() {
                // Make sure expanded list is updated if needed
                if (_expandedList.length != RumahDummy.dummyData.length) {
                  _initExpandedList();
                }
              });
            }
          } : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hanya rumah dengan status "Tersedia" yang dapat diedit')),
            );
          },
          onDetailPressed: () {
            context.pushNamed(
              'rumah_detail',
              queryParameters: {
                'index': index.toString(),
                'address': rumah.address,
              },
            );
          },
        ),
      ],
    );
  }
}