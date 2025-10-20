import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
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
          return _buildHouseCard(
            address: rumah.address,
            status: rumah.status,
            statusColor: rumah.statusColor,
            isExpanded: index < _expandedList.length ? _expandedList[index] : false,
            index: index,
          );
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
                // Add safety check before accessing _expandedList
                if (index < _expandedList.length) {
                  _expandedList[index] = !_expandedList[index];
                }
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
                      // House details
                      const Text("Alamat Lengkap:"),
                      Text(address),
                      const SizedBox(height: 8),

                      // Action buttons
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: status == 'Tersedia' ? () async {
                            final result = await context.pushNamed(
                              'rumah_edit',
                              queryParameters: {
                                'index': index.toString(),
                                'address': address,
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
                              'rumah_detail',
                              queryParameters: {
                                'index': index.toString(),
                                'address': address,
                              },
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