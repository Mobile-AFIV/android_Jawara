import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class LaporanTab extends StatefulWidget {
  const LaporanTab({super.key});

  @override
  State<LaporanTab> createState() => _LaporanTabState();
}

class _LaporanTabState extends State<LaporanTab> {
  bool isLoadingPemasukan = true;
  bool isLoadingPengeluaran = true;

  List<Pemasukan> pemasukanList = [];
  List<Pengeluaran> pengeluaranList = [];

  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  int jumlahTransaksiPemasukan = 0;
  int jumlahTransaksiPengeluaran = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadPemasukan(),
      _loadPengeluaran(),
    ]);
  }

  Future<void> _loadPemasukan() async {
    setState(() {
      isLoadingPemasukan = true;
    });

    try {
      final data = await PemasukanService.instance.getAllPemasukan();
      setState(() {
        pemasukanList = data;
        jumlahTransaksiPemasukan = data.length;
        totalPemasukan = data.fold<int>(0, (sum, item) => sum + item.nominal);
        isLoadingPemasukan = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPemasukan = false;
      });
    }
  }

  Future<void> _loadPengeluaran() async {
    setState(() {
      isLoadingPengeluaran = true;
    });

    try {
      final data = await PengeluaranService.instance.getAllPengeluaran();
      setState(() {
        pengeluaranList = data;
        jumlahTransaksiPengeluaran = data.length;
        totalPengeluaran = data.fold<int>(0, (sum, item) => sum + item.nominal);
        isLoadingPengeluaran = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPengeluaran = false;
      });
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60 + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LAPORAN PEMASUKAN SECTION
            HeadingSection(
              headingText: "Rekapitulasi seluruh pemasukan",
              subHeadingText: "Laporan Pemasukan",
              lainnyaOnPressed: () => context.pushNamed('laporan_Pemasukan'),
            ),
            _buildPemasukanPreview(),

            // LAPORAN PENGELUARAN SECTION
            HeadingSection(
              headingText: "Rekapitulasi seluruh pengeluaran",
              subHeadingText: "Laporan Pengeluaran",
              lainnyaOnPressed: () => context.pushNamed('laporan_pengeluaran'),
            ),
            _buildPengeluaranPreview(),

            // CETAK LAPORAN SECTION
            HeadingSection(
              headingText: "Lihat dan cetak laporan keuangan",
              subHeadingText: "Cetak Laporan",
              lainnyaOnPressed: () => context.pushNamed('cetak_laporan'),
            ),
            _buildCetakLaporanPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildCetakLaporanPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppStyles.primaryColor.withOpacity(0.1),
            AppStyles.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppStyles.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.print_rounded,
            size: 48,
            color: AppStyles.primaryColor,
          ),
          const SizedBox(height: 12),
          const Text(
            "Cetak Laporan PDF",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Generate dan cetak laporan keuangan dalam format PDF",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(
                icon: Icons.calendar_today,
                label: "Pilih Periode",
                color: Colors.blue,
              ),
              _buildInfoChip(
                icon: Icons.category,
                label: "Pilih Jenis",
                color: Colors.orange,
              ),
              _buildInfoChip(
                icon: Icons.download_rounded,
                label: "Download",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPemasukanPreview() {
    if (isLoadingPemasukan) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const StatsCardShimmer(),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pemasukan",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(totalPemasukan),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.green.shade200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                label: "Transaksi",
                value: jumlahTransaksiPemasukan.toString(),
                icon: Icons.receipt_long,
                color: Colors.green,
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.green.shade200,
              ),
              _buildStatItem(
                label: "Rata-rata",
                value: jumlahTransaksiPemasukan > 0
                    ? _formatCurrency(
                        (totalPemasukan / jumlahTransaksiPemasukan).round())
                    : "Rp 0",
                icon: Icons.analytics,
                color: Colors.green,
              ),
            ],
          ),
          if (pemasukanList.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.green.shade200),
            const SizedBox(height: 12),
            const Text(
              "Transaksi Terakhir:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...pemasukanList.take(3).map((pemasukan) => _buildTransactionItem(
                  nama: pemasukan.nama,
                  kategori: pemasukan.kategori,
                  tanggal: pemasukan.tanggal,
                  nominal: pemasukan.nominal,
                  isIncome: true,
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildPengeluaranPreview() {
    if (isLoadingPengeluaran) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const StatsCardShimmer(),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade50,
            Colors.red.shade100.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_down,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pengeluaran",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(totalPengeluaran),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.red.shade200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                label: "Transaksi",
                value: jumlahTransaksiPengeluaran.toString(),
                icon: Icons.receipt_long,
                color: Colors.red,
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.red.shade200,
              ),
              _buildStatItem(
                label: "Rata-rata",
                value: jumlahTransaksiPengeluaran > 0
                    ? _formatCurrency(
                        (totalPengeluaran / jumlahTransaksiPengeluaran).round())
                    : "Rp 0",
                icon: Icons.analytics,
                color: Colors.red,
              ),
            ],
          ),
          if (pengeluaranList.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.red.shade200),
            const SizedBox(height: 12),
            const Text(
              "Transaksi Terakhir:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...pengeluaranList
                .take(3)
                .map((pengeluaran) => _buildTransactionItem(
                      nama: pengeluaran.nama,
                      kategori: pengeluaran.kategori,
                      tanggal: pengeluaran.tanggal,
                      nominal: pengeluaran.nominal,
                      isIncome: false,
                    )),
          ],
          // Saldo Info
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: totalPemasukan - totalPengeluaran >= 0
                          ? Colors.green
                          : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Saldo Bersih:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatCurrency(totalPemasukan - totalPengeluaran),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: totalPemasukan - totalPengeluaran >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String nama,
    required String kategori,
    required DateTime tanggal,
    required int nominal,
    required bool isIncome,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "$kategori • ${DateFormat('dd/MM/yyyy').format(tanggal)}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatCurrency(nominal),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
