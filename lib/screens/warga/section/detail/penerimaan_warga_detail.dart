import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/screens/warga/section/widget/detail_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/status_field.dart';
import 'package:jawara_pintar/screens/warga/section/widget/resident_application_actions.dart';
import 'package:jawara_pintar/screens/warga/section/widget/back_button.dart';
import 'package:jawara_pintar/screens/warga/section/widget/form_text_field.dart';

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
    if (widget.penerimaanData != null) {
      setState(() {
        penerimaan = widget.penerimaanData!;
        _isLoading = false;
      });
    } else if (widget.penerimaanId != null && widget.penerimaanId!.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('penerimaan_warga')
            .doc(widget.penerimaanId)
            .get();

        if (doc.exists) {
          setState(() {
            penerimaan = doc.data()!;
            penerimaan['id'] = doc.id;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data penerimaan tidak ditemukan')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data: $e')),
          );
          Navigator.pop(context);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to accept an application
  Future<void> _acceptResident() async {
    try {
      await FirebaseFirestore.instance
          .collection('penerimaan_warga')
          .doc(widget.penerimaanId ?? penerimaan['id'])
          .update({
        'registrationStatus': 'Diterima',
        'rejectionReason': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        penerimaan['registrationStatus'] = 'Diterima';
        penerimaan['rejectionReason'] = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${penerimaan['name'] ?? 'Warga'} telah diterima sebagai warga')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menerima pendaftaran: $e')),
        );
      }
    }
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
              FormTextField(
                controller: reasonController,
                label: 'Alasan Penolakan',
                hintText: 'Contoh: Data tidak lengkap',
                isRequired: true,
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
              onPressed: () async {
                if (reasonController.text.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('penerimaan_warga')
                        .doc(widget.penerimaanId ?? penerimaan['id'])
                        .update({
                      'registrationStatus': 'Ditolak',
                      'rejectionReason': reasonController.text,
                      'updatedAt': FieldValue.serverTimestamp(),
                    });

                    setState(() {
                      penerimaan['registrationStatus'] = 'Ditolak';
                      penerimaan['rejectionReason'] = reasonController.text;
                    });

                    Navigator.of(context).pop();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Pendaftaran ${penerimaan['name'] ?? 'warga'} telah ditolak')),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Gagal menolak pendaftaran: $e')),
                      );
                    }
                  }
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

                    // KTP Image
                    if (penerimaan['ktpImageUrl'] != null &&
                        penerimaan['ktpImageUrl'].toString().isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Foto KTP:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.network(
                                            penerimaan['ktpImageUrl'],
                                            fit: BoxFit.contain,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(50),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.black54,
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                penerimaan['ktpImageUrl'],
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image,
                                              size: 50, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text('Gagal memuat gambar',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap untuk memperbesar',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                    // Registration Status
                    const SizedBox(height: 16),
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
