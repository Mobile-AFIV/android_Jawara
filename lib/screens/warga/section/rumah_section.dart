import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RumahSection extends StatefulWidget {
  const RumahSection({super.key});

  @override
  State<RumahSection> createState() => _RumahSectionState();
}

class _RumahSectionState extends State<RumahSection> {
  // Track which cards are expanded
  final List<bool> _expandedList = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Rumah"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // First house
          _buildHouseCard(
            address: 'Jl. Dahlia No. 15, RT 003/RW 002',
            status: 'Milik Sendiri',
            statusColor: Colors.green,
            isExpanded: _expandedList[0],
            index: 0,
          ),
          const SizedBox(height: 12),

          // Second house
          _buildHouseCard(
            address: 'Jl. Mawar No. 23, RT 005/RW 002',
            status: 'Sewa',
            statusColor: Colors.blue,
            isExpanded: _expandedList[1],
            index: 1,
          ),
          const SizedBox(height: 12),

          // Third house
          _buildHouseCard(
            address: 'Jl. Melati No. 8, RT 002/RW 003',
            status: 'Milik Keluarga',
            statusColor: Colors.purple,
            isExpanded: _expandedList[2],
            index: 2,
          ),
          const SizedBox(height: 12),

          // Fourth house
          _buildHouseCard(
            address: 'Jl. Anggrek No. 42, RT 004/RW 001',
            status: 'Kontrak',
            statusColor: Colors.orange,
            isExpanded: _expandedList[3],
            index: 3,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor.withValues(alpha: 1),
        foregroundColor: Colors.white,
        onPressed: () {
          context.pushNamed('rumah_tambah');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHouseCard({
    required String address,
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
                  // Left side: Address (shortened if necessary)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.length > 30 ? "${address.substring(0, 30)}..." : address,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "status: $status",
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "aktif",
                      style: TextStyle(
                        color: Colors.green[800],
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
                      // House details
                      Text("Alamat Lengkap:"),
                      Text(address),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("Status Kepemilikan: "),
                          Chip(
                            label: Text(status),
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