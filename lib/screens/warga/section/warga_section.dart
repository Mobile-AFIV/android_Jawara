import 'package:flutter/material.dart';

class WargaSection extends StatefulWidget {
  const WargaSection({super.key});

  @override
  State<WargaSection> createState() => _WargaSectionState();
}

class _WargaSectionState extends State<WargaSection> {
  // Track which cards are expanded
  final List<bool> _expandedList = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Warga"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // First card (expanded by default)
          _buildWargaCard(
            name: "Budi Santoso",
            nik: "3507012345678901",
            family: "Kepala Keluarga",
            gender: "Laki-laki",
            domicileStatus: "Tetap",
            lifeStatus: "Hidup",
            isExpanded: _expandedList[0],
            index: 0,
          ),
          const SizedBox(height: 12),

          // Second card
          _buildWargaCard(
            name: "Siti Rahayu",
            nik: "3507012345678902",
            family: "Istri",
            gender: "Perempuan",
            domicileStatus: "Tetap",
            lifeStatus: "Hidup",
            isExpanded: _expandedList[1],
            index: 1,
          ),
          const SizedBox(height: 12),

          // Third card
          _buildWargaCard(
            name: "Ahmad Fauzi",
            nik: "3507012345678903",
            family: "Anak",
            gender: "Laki-laki",
            domicileStatus: "Tidak Tetap",
            lifeStatus: "Hidup",
            isExpanded: _expandedList[2],
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildWargaCard({
    required String name,
    required String nik,
    required String family,
    required String gender,
    required String domicileStatus,
    required String lifeStatus,
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
                  // Left side: Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "status: $lifeStatus",
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
                      // Resident details
                      Text("NIK: $nik"),
                      Text("Keluarga: $family"),
                      Text("Jenis Kelamin: $gender"),
                      Text("Status Domisili: $domicileStatus"),

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