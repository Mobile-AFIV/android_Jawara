import 'package:flutter/material.dart';

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
            mutationType: 'Pindah Masuk',
            statusColor: Colors.green,
            isExpanded: _expandedList[0],
            index: 0,
          ),
          const SizedBox(height: 12),

          // Second mutation
          _buildMutationCard(
            familyName: 'Keluarga Fikri',
            date: '30 November 2023',
            mutationType: 'Pindah Keluar',
            statusColor: Colors.orange,
            isExpanded: _expandedList[1],
            index: 1,
          ),
          const SizedBox(height: 12),

          // Third mutation
          _buildMutationCard(
            familyName: 'Keluarga Ahmad',
            date: '15 Januari 2024',
            mutationType: 'Kelahiran',
            statusColor: Colors.blue,
            isExpanded: _expandedList[2],
            index: 2,
          ),
          const SizedBox(height: 12),

          // Fourth mutation
          _buildMutationCard(
            familyName: 'Keluarga Santoso',
            date: '7 Maret 2024',
            mutationType: 'Kematian',
            statusColor: Colors.grey,
            isExpanded: _expandedList[3],
            index: 3,
          ),
        ],
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Jenis Mutasi: "),
                          Chip(
                            label: Text(mutationType),
                            backgroundColor: statusColor[100],
                            labelStyle: TextStyle(color: statusColor[800]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),

                      // Additional details specific to mutation type
                      _buildMutationDetails(mutationType),

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

  // Helper method to show different details based on mutation type
  Widget _buildMutationDetails(String mutationType) {
    switch (mutationType) {
      case 'Pindah Masuk':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text("Alamat Asal: Jl. Veteran No. 45, Jakarta Selatan"),
            Text("No. Surat Pindah: PM-2023-10-001"),
          ],
        );
      case 'Pindah Keluar':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text("Alamat Tujuan: Jl. Raya Bogor Km. 30, Depok"),
            Text("No. Surat Pindah: PK-2023-11-002"),
          ],
        );
      case 'Kelahiran':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text("Nama Anak: Aditya Ahmad"),
            Text("Tempat Lahir: RS Bunda, Jakarta"),
            Text("No. Akta Kelahiran: AK-2024-01-005"),
          ],
        );
      case 'Kematian':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text("Nama Almarhum: Bambang Santoso"),
            Text("Penyebab: Sakit"),
            Text("No. Surat Kematian: SK-2024-03-008"),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}