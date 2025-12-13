import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/tagihan_iuran.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/services/tagihan_iuran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class DetailTagihanSection extends StatefulWidget {
  final String tagihanId;

  const DetailTagihanSection({
    super.key,
    required this.tagihanId,
  });

  @override
  State<DetailTagihanSection> createState() => _DetailTagihanSectionState();
}

class _DetailTagihanSectionState extends State<DetailTagihanSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TagihanIuran? tagihan;
  List<RiwayatPembayaran> riwayatList = [];
  RiwayatPembayaran? latestRiwayat;
  bool isLoading = true;
  bool isSubmitting = false;

  final TextEditingController catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final tagihanData =
          await TagihanIuranService.instance.getTagihanById(widget.tagihanId);
      final riwayatData = await TagihanIuranService.instance
          .getRiwayatPembayaranByTagihanId(widget.tagihanId);
      final latest = await TagihanIuranService.instance
          .getLatestRiwayatPembayaran(widget.tagihanId);

      setState(() {
        tagihan = tagihanData;
        riwayatList = riwayatData;
        latestRiwayat = latest;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('d MMMM yyyy HH:mm', 'id').format(date);
  }

  Color _getStatusColor(StatusPembayaran status) {
    switch (status) {
      case StatusPembayaran.belum:
        return Colors.grey;
      case StatusPembayaran.menunggu:
        return AppStyles.warningOnSurfaceColor;
      case StatusPembayaran.diterima:
        return AppStyles.successColor;
      case StatusPembayaran.ditolak:
        return AppStyles.errorColor;
    }
  }

  Future<void> _verifikasiPembayaran(bool disetujui) async {
    if (catatanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await TagihanIuranService.instance.verifikasiPembayaran(
        idTagihan: widget.tagihanId,
        disetujui: disetujui,
        catatan: catatanController.text.trim(),
        verifikator: 'Admin Jawara',
        buktiUrl: latestRiwayat?.buktiUrl,
      );

      setState(() {
        isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Pembayaran ${disetujui ? "disetujui" : "ditolak"} berhasil'),
            backgroundColor: Colors.green,
          ),
        );

        // Reload data
        _loadData();
        catatanController.clear();
      }
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Verifikasi Pembayaran Iuran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppStyles.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppStyles.primaryColor,
          tabs: const [
            Tab(text: "Detail"),
            Tab(text: "Riwayat Pembayaran"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tagihan == null
              ? const Center(
                  child: Text(
                    'Data tagihan tidak ditemukan',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailTab(),
                    _buildRiwayatTab(),
                  ],
                ),
    );
  }

  Widget _buildDetailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem("Kode Iuran", widget.tagihanId),
          const SizedBox(height: 16),
          _buildInfoItem("Nama Iuran", tagihan!.kategoriIuran),
          const SizedBox(height: 16),
          _buildInfoItem("Kategori", "Iuran"),
          const SizedBox(height: 16),
          _buildInfoItem("Periode", _formatDate(tagihan!.periode)),
          const SizedBox(height: 16),
          _buildInfoItem("Nominal", _formatCurrency(tagihan!.nominal)),
          const SizedBox(height: 16),
          _buildInfoItem(
            "Status",
            tagihan!.statusPembayaran.label,
            statusColor: _getStatusColor(tagihan!.statusPembayaran),
          ),
          const SizedBox(height: 16),
          _buildInfoItem("Nama KK", tagihan!.namaKeluarga),
          const SizedBox(height: 16),
          _buildInfoItem("Alamat", tagihan!.alamat),
          const SizedBox(height: 16),
          _buildInfoItem(
            "Metode Pembayaran",
            tagihan!.metodePembayaran ?? "Belum tersedia",
          ),

          // Jika ada pembayaran yang menunggu persetujuan
          if (tagihan!.statusPembayaran == StatusPembayaran.menunggu &&
              latestRiwayat != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Bukti Pembayaran
            if (latestRiwayat!.buktiUrl != null) ...[
              const Text(
                "Bukti Pembayaran",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  latestRiwayat!.buktiUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Form Verifikasi
            const Text(
              "Catatan Verifikasi",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: catatanController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Masukkan catatan (wajib diisi)",
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons Verifikasi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => _verifikasiPembayaran(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppStyles.errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Tolak",
                            style: TextStyle(color: AppStyles.errorColor),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    onPressed:
                        isSubmitting ? null : () => _verifikasiPembayaran(true),
                    customBackgroundColor: AppStyles.successColor,
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Setujui",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiwayatTab() {
    if (riwayatList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Belum ada riwayat pembayaran.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: riwayatList.length,
      itemBuilder: (context, index) {
        final riwayat = riwayatList[index];
        return _buildRiwayatCard(riwayat);
      },
    );
  }

  Widget _buildRiwayatCard(RiwayatPembayaran riwayat) {
    Color statusColor = _getStatusColor(riwayat.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Status:",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  riwayat.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Catatan (jika ditolak atau diterima)
          if (riwayat.catatan != null && riwayat.catatan!.isNotEmpty) ...[
            const Text(
              "Catatan:",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              riwayat.catatan!,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],

          // Tanggal
          Row(
            children: [
              const Text(
                "Tanggal:",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDateTime(riwayat.tanggal),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          // Bukti
          if (riwayat.buktiUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                riwayat.buktiUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: statusColor,
            fontWeight: statusColor != null ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}
