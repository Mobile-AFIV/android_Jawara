import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/data/penerimaan_warga_dummy.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:go_router/go_router.dart';

class PenerimaanWargaDetail extends StatefulWidget {
  final int penerimaanIndex;
  final String? name; // Add name parameter for better lookup

  const PenerimaanWargaDetail({
    super.key,
    required this.penerimaanIndex,
    this.name,
  });

  @override
  State<PenerimaanWargaDetail> createState() => _PenerimaanWargaDetailState();
}

class _PenerimaanWargaDetailState extends State<PenerimaanWargaDetail> {
  late PenerimaanWargaModel penerimaan;

  @override
  void initState() {
    super.initState();

    // First try to find by name if provided
    if (widget.name != null && widget.name!.isNotEmpty) {
      final matchByName = PenerimaanWargaDummy.dummyData.where(
              (p) => p.name == widget.name
      ).toList();

      if (matchByName.isNotEmpty) {
        penerimaan = matchByName.first;
        return;
      }
    }

    // Fall back to index-based lookup
    penerimaan = widget.penerimaanIndex >= 0 && widget.penerimaanIndex < PenerimaanWargaDummy.dummyData.length
        ? PenerimaanWargaDummy.dummyData[widget.penerimaanIndex]
        : PenerimaanWargaDummy.dummyData.last; // Use the example data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Penerimaan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pendaftaran Warga",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Profile section with image, name and email
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        penerimaan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        penerimaan.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // NIK
              _buildDetailField("NIK:", penerimaan.nik),

              // Gender
              _buildDetailField("Jenis Kelamin:", penerimaan.gender),

              // Registration Status
              _buildStatusField("Status Pendaftaran:", penerimaan.registrationStatus, penerimaan.statusColor),

              const SizedBox(height: 24),
              // Back button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kembali'),
                ),
              ),

              if (penerimaan.registrationStatus == 'Menunggu')
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[100],
                              foregroundColor: Colors.green[800],
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Tolak'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusField(String label, String value, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}