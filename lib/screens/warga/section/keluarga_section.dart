import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class KeluargaSection extends StatefulWidget {
  const KeluargaSection({super.key});

  @override
  State<KeluargaSection> createState() => _KeluargaSectionState();
}

class _KeluargaSectionState extends State<KeluargaSection> {
  // Track which cards are expanded
  final List<bool> _expandedList = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Keluarga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // First family
          _buildFamilyCard(
            familyName: 'Keluarga Santoso',
            headOfFamily: 'Budi Santoso',
            address: 'Jl. Dahlia No. 15, RT 003/RW 002',
            ownershipStatus: 'Penyewa',
            status: 'Aktif',
            statusColor: Colors.green,
            isExpanded: _expandedList[0],
            index: 0,
          ),
          const SizedBox(height: 12),

          // Second family
          _buildFamilyCard(
            familyName: 'Keluarga Rahmad',
            headOfFamily: 'Ahmad Rahmad',
            address: 'Jl. Mawar No. 23, RT 005/RW 002',
            ownershipStatus: 'Pemilik',
            status: 'Aktif',
            statusColor: Colors.green,
            isExpanded: _expandedList[1],
            index: 1,
          ),
          const SizedBox(height: 12),

          // Third family
          _buildFamilyCard(
            familyName: 'Keluarga Wijaya',
            headOfFamily: 'Hendra Wijaya',
            address: 'Jl. Melati No. 8, RT 002/RW 003',
            ownershipStatus: 'Pemilik',
            status: 'Nonaktif',
            statusColor: Colors.red,
            isExpanded: _expandedList[2],
            index: 2,
          ),
          const SizedBox(height: 12),

          // Fourth family
          _buildFamilyCard(
            familyName: 'Keluarga Prasetyo',
            headOfFamily: 'Dimas Prasetyo',
            address: 'Jl. Anggrek No. 42, RT 004/RW 001',
            ownershipStatus: 'Penyewa',
            status: 'Nonaktif',
            statusColor: Colors.red,
            isExpanded: _expandedList[3],
            index: 3,
          ),
        ],
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
                      "$status",
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