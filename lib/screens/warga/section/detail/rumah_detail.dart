import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/rumah_dummy.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/resident_history_item.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class RumahDetail extends StatefulWidget {
  final int rumahIndex;
  final String? address; // Add address parameter for better lookup

  const RumahDetail({
    super.key,
    required this.rumahIndex,
    this.address,
  });

  @override
  State<RumahDetail> createState() => _RumahDetailState();
}

class _RumahDetailState extends State<RumahDetail> {
  late RumahModel rumah;

  @override
  void initState() {
    super.initState();

    // First try to find by address if provided
    if (widget.address != null && widget.address!.isNotEmpty) {
      final matchByAddress = RumahDummy.dummyData.where(
              (r) => r.address == widget.address
      ).toList();

      if (matchByAddress.isNotEmpty) {
        rumah = matchByAddress.first;
        return;
      }
    }

    // Fall back to index-based lookup
    rumah = widget.rumahIndex >= 0 && widget.rumahIndex < RumahDummy.dummyData.length
        ? RumahDummy.dummyData[widget.rumahIndex]
        : RumahDummy.dummyData.last; // Use the example data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rumah"),
      ),
      body: SingleChildScrollView(
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
                  DetailField(label: "Alamat:", value: rumah.address),

                  // Status
                  StatusField(label: "Status:", value: rumah.status, color: rumah.statusColor),
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
                  ...rumah.residentHistory.map((resident) => ResidentHistoryItem(resident: resident)).toList(),

                  if (rumah.residentHistory.isEmpty)
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