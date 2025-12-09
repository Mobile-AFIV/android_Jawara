import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/resident_history_item.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class RumahDetail extends StatefulWidget {
  final String? rumahId;
  final Map<String, dynamic>? rumahData;

  const RumahDetail({
    super.key,
    this.rumahId,
    this.rumahData,
  });

  @override
  State<RumahDetail> createState() => _RumahDetailState();
}

class _RumahDetailState extends State<RumahDetail> {
  Map<String, dynamic> rumah = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Load data from Firebase using RumahService and rumahId
    if (widget.rumahData != null) {
      setState(() {
        rumah = widget.rumahData!;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch from Firebase using widget.rumahId
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rumah"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // House details section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail Rumah",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Address
                        DetailField(
                            label: "Alamat:", value: rumah['address'] ?? ''),

                        // Status
                        StatusField(
                          label: "Status:",
                          value: rumah['status'] ?? 'Tersedia',
                          color:
                              (rumah['status'] ?? 'Tersedia').toLowerCase() ==
                                      'tersedia'
                                  ? Colors.green
                                  : Colors.blue,
                        ),
                      ],
                    ),
                  ),

                  // Divider between sections
                  Container(
                    height: 8,
                    color: Colors.grey[200],
                  ),

                  // Resident history section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Riwayat Penghuni",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // List of residents
                        if (rumah['residentHistory'] != null &&
                            (rumah['residentHistory'] as List).isNotEmpty)
                          ...(rumah['residentHistory'] as List)
                              .map((resident) =>
                                  ResidentHistoryItem(resident: resident))
                              .toList()
                        else
                          const Text(
                            "Belum ada riwayat penghuni",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Back button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DetailBackButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
