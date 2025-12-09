import 'package:flutter/material.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/resident_application_actions.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';

class PenerimaanWargaDetail extends StatefulWidget {
  final String? penerimaanId;
  final Map<String, dynamic>? penerimaanData;

  const PenerimaanWargaDetail({
    super.key,
    this.penerimaanId,
    this.penerimaanData,
  });

  @override
  State<PenerimaanWargaDetail> createState() => _PenerimaanWargaDetailState();
}

class _PenerimaanWargaDetailState extends State<PenerimaanWargaDetail> {
  Map<String, dynamic> penerimaan = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Load data from Firebase using penerimaanId
    if (widget.penerimaanData != null) {
      setState(() {
        penerimaan = widget.penerimaanData!;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch from Firebase using widget.penerimaanId
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to accept an application
  void _acceptResident() {
    setState(() {
      penerimaan['registrationStatus'] = 'Diterima';
      penerimaan['rejectionReason'] = null;
    });

    // TODO: Update Firebase with new status

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${penerimaan['name'] ?? 'Warga'} telah diterima sebagai warga')),
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
                    penerimaan['registrationStatus'] = 'Ditolak';
                    penerimaan['rejectionReason'] = reasonController.text;
                  });

                  // TODO: Update Firebase with new status

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Pendaftaran ${penerimaan['name'] ?? 'warga'} telah ditolak')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Alasan penolakan harus diisi')),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              penerimaan['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              penerimaan['email'] ?? '',
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
                    DetailField(label: "NIK:", value: penerimaan['nik'] ?? ''),

                    // Gender
                    DetailField(
                        label: "Jenis Kelamin:",
                        value: penerimaan['gender'] ?? ''),

                    // Registration Status
                    StatusField(
                      label: "Status Pendaftaran:",
                      value: penerimaan['registrationStatus'] ?? 'Menunggu',
                      color: _getStatusColor(
                          penerimaan['registrationStatus'] ?? 'Menunggu'),
                    ),

                    // Show rejection reason if status is Ditolak
                    if (penerimaan['registrationStatus'] == 'Ditolak' &&
                        penerimaan['rejectionReason'] != null)
                      DetailField(
                          label: "Alasan Ditolak:",
                          value: penerimaan['rejectionReason'] ?? ''),

                    const SizedBox(height: 24),

                    // Actions based on status
                    ResidentApplicationActions(
                      penerimaan: penerimaan,
                      onAccept: _acceptResident,
                      onShowRejectionDialog: _showRejectionDialog,
                    ),

                    const SizedBox(height: 16),
                    // Back button
                    DetailBackButton(
                      onPressed: () => Navigator.pop(
                          context, true), // Return with refresh flag
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  MaterialColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
