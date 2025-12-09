import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (widget.rumahData != null) {
      setState(() {
        rumah = widget.rumahData!;
        _isLoading = false;
      });
    } else if (widget.rumahId != null && widget.rumahId!.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('rumah_warga')
            .doc(widget.rumahId)
            .get();

        if (doc.exists) {
          setState(() {
            rumah = doc.data()!;
            rumah['id'] = doc.id;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data rumah tidak ditemukan')),
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

  Future<void> _deleteRumah() async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data rumah ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Delete from Firebase
        if (widget.rumahId != null && widget.rumahId!.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('rumah_warga')
              .doc(widget.rumahId)
              .delete();
        }

        // Close loading
        if (mounted) Navigator.pop(context);

        // Show success and return
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data rumah berhasil dihapus')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        // Close loading
        if (mounted) Navigator.pop(context);

        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rumah"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteRumah,
            tooltip: 'Hapus Rumah',
          ),
        ],
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
