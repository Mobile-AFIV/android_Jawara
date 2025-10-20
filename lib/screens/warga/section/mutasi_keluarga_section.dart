import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class MutasiKeluargaSection extends StatefulWidget {
  const MutasiKeluargaSection({super.key});

  @override
  State<MutasiKeluargaSection> createState() => _MutasiKeluargaSectionState();
}

class _MutasiKeluargaSectionState extends State<MutasiKeluargaSection> {
  // Track which cards are expanded
  final List<bool> _expandedList = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mutasi Keluarga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // First mutation
          _buildMutationCard(
            familyName: 'Keluarga Jeha',
            date: '25 Oktober 2023',
            mutationType: 'Pindah Rumah',
            statusColor: Colors.green,
            isExpanded: _expandedList[0],
            index: 0,
          ),
          const SizedBox(height: 12),

          // Second mutation
          _buildMutationCard(
            familyName: 'Keluarga Fikri',
            date: '30 November 2023',
            mutationType: 'Keluar Wilayah',
            statusColor: Colors.red,
            isExpanded: _expandedList[1],
            index: 1,
          ),
          const SizedBox(height: 12),

          // Third mutation
          _buildMutationCard(
            familyName: 'Keluarga Ahmad',
            date: '15 Januari 2024',
            mutationType: 'Pindah Masuk',
            statusColor: Colors.green,
            isExpanded: _expandedList[2],
            index: 2,
          ),
          const SizedBox(height: 12),

          // Fourth mutation
          _buildMutationCard(
            familyName: 'Keluarga Santoso',
            date: '7 Maret 2024',
            mutationType: 'Pindah Masuk',
            statusColor: Colors.green,
            isExpanded: _expandedList[3],
            index: 3,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () {
          context.pushNamed('mutasi_keluarga_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMutationCard({
    required String familyName,
    required String date,
    required String mutationType,
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
                  // Left side: Family name and date
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
                          "tanggal: $date",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side: Mutation type chip and expand arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      mutationType,
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
                      // Mutation details
                      Text("Nama Keluarga: $familyName"),
                      Text("Tanggal Mutasi: $date"),
                      Text("Jenis Mutasi: $mutationType"),
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
                          onPressed: () {},
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