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

  // Method to accept an application
  void _acceptResident() {
    setState(() {
      penerimaan.registrationStatus = 'Diterima';
      penerimaan.statusColor = Colors.green;
      penerimaan.rejectionReason = null; // Clear the rejection reason
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${penerimaan.name} telah diterima sebagai warga')),
    );
  }

  // Method to show rejection dialog and handle rejection
  void _showRejectionDialog() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tolak Pendaftaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan alasan penolakan:'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Data tidak lengkap',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isNotEmpty) {
                  setState(() {
                    penerimaan.registrationStatus = 'Ditolak';
                    penerimaan.statusColor = Colors.red;
                    penerimaan.rejectionReason = reasonController.text;
                  });

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pendaftaran ${penerimaan.name} telah ditolak')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alasan penolakan harus diisi')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tolak'),
            ),
          ],
        );
      },
    ).then((_) {
      reasonController.dispose();
    });
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
                    decoration: const BoxDecoration(
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

              // Show rejection reason if status is Ditolak
              if (penerimaan.registrationStatus == 'Ditolak' && penerimaan.rejectionReason != null)
                _buildDetailField("Alasan Ditolak:", penerimaan.rejectionReason!),

              const SizedBox(height: 24),

              // Actions based on status
              _buildActionButtons(),

              const SizedBox(height: 16),
              // Back button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Return with refresh flag
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kembali'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build appropriate action buttons based on status
  Widget _buildActionButtons() {
    // For applications with "Menunggu" status, show both accept and reject buttons
    if (penerimaan.registrationStatus == 'Menunggu') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _acceptResident,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Terima'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _showRejectionDialog,
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
      );
    }
    // For rejected applications, show only the accept button
    else if (penerimaan.registrationStatus == 'Ditolak') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _acceptResident,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            foregroundColor: Colors.green[800],
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Terima Pendaftaran'),
        ),
      );
    }
    // For accepted applications, show no action buttons
    else {
      return const SizedBox.shrink();
    }
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