import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/keluarga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

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
          return _buildFamilyCard(
            familyName: keluarga.familyName,
            headOfFamily: keluarga.headOfFamily,
            address: keluarga.address,
            ownershipStatus: keluarga.ownershipStatus,
            status: keluarga.status,
            statusColor: keluarga.statusColor,
            isExpanded: _expandedList[index],
            index: index,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }

  Widget _buildFamilyCard({
    required String familyName,
    required String headOfFamily,
    required String address,
    required String ownershipStatus,
    required String status,
    required MaterialColor statusColor,
    required bool isExpanded,
    required int index,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header section (always visible)
          InkWell(
            onTap: () {
              setState(() {
                _expandedList[index] = !_expandedList[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Left side: Family name and head of family
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          familyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "kepala: $headOfFamily",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side: Status chip and expand arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded details section (only visible when expanded)
          if (isExpanded)
            Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Family details
                      Text("Nama Keluarga: $familyName"),
                      Text("Kepala Keluarga: $headOfFamily"),
                      Text("Alamat: $address"),
                      Text("Status Kepemilikan: $ownershipStatus"),
                      const SizedBox(height: 8),

                      // Action buttons
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[100],
                            foregroundColor: Colors.amber[800],
                            elevation: 0,
                          ),
                          child: const Text('edit'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.pushNamed(
                              'keluarga_detail',
                              queryParameters: {'index': index.toString()},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[800],
                            elevation: 0,
                          ),
                          child: const Text('detail'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}