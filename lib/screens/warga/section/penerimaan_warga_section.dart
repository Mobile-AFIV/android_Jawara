import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/warga/section/data/penerimaan_warga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PenerimaanWargaSection extends StatefulWidget {
  const PenerimaanWargaSection({super.key});

  @override
  State<PenerimaanWargaSection> createState() => _PenerimaanWargaSectionState();
}

class _PenerimaanWargaSectionState extends State<PenerimaanWargaSection> {
  // Track which cards are expanded
  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _expandedList = List.generate(PenerimaanWargaDummy.dummyData.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Penerimaan Warga"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: PenerimaanWargaDummy.dummyData.length,
        itemBuilder: (context, index) {
          final penerimaan = PenerimaanWargaDummy.dummyData[index];
          return _buildRegistrationCard(
            name: penerimaan.name,
            nik: penerimaan.nik,
            email: penerimaan.email,
            gender: penerimaan.gender,
            registrationStatus: penerimaan.registrationStatus,
            statusColor: penerimaan.statusColor,
            isExpanded: _expandedList[index],
            index: index,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }

  // Method to show the identity photo
  void _showIdentityPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBar(
                  title: const Text("Foto Identitas"),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // const Padding(padding: EdgeInsets.all(16.0))
              Image.asset(
                'assets/images/placeholder.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Handle image loading error
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.broken_image, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Gambar tidak ditemukan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Foto KTP/Identitas"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegistrationCard({
    required String name,
    required String nik,
    required String email,
    required String gender,
    required String registrationStatus,
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
                      registrationStatus,
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
                      // Registration details
                      Text("NIK: $nik"),
                      Text("Email: $email"),
                      Text("Jenis Kelamin: $gender"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Foto Identitas: "),
                          const Icon(Icons.image, size: 20),
                          TextButton(
                            onPressed: () {
                              // Open the identity photo
                              _showIdentityPhoto(context);
                            },
                            child: const Text('Lihat'),
                          ),
                        ],
                      ),

                      // Action buttons
                      const SizedBox(height: 16),
                      if (registrationStatus == 'Menunggu')
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[100],
                                  foregroundColor: Colors.green[800],
                                  elevation: 0,
                                ),
                                child: const Text('Terima'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[100],
                                  foregroundColor: Colors.red[800],
                                  elevation: 0,
                                ),
                                child: const Text('Tolak'),
                              ),
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pushNamed(
                                'penerimaan_warga_detail',
                                queryParameters: {
                                  'index': index.toString(),
                                  'name': name,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.blue[800],
                              elevation: 0,
                            ),
                            child: const Text('Detail'),
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