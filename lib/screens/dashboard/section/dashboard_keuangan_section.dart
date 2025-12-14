import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/kegiatan.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/kegiatan_service.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class DashboardKeuanganSection extends StatefulWidget {
  const DashboardKeuanganSection({super.key});

  @override
  State<DashboardKeuanganSection> createState() =>
      _DashboardKeuanganSectionState();
}

class _DashboardKeuanganSectionState extends State<DashboardKeuanganSection> {
  bool isLoading = true;
  List<Pemasukan> pemasukanList = [];
  List<Pengeluaran> pengeluaranList = [];
  List<KegiatanModel> kegiatanList = [];

  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  int totalAnggaranKegiatan = 0;
  int saldo = 0;

  Map<String, int> pemasukanPerKategori = {};
  Map<String, int> pengeluaranPerKategori = {};
  Map<String, int> monthlyData = {}; // Format: "MMM yyyy" -> total

  // Pagination state
  int transaksiCurrentPage = 0;
  int kegiatanCurrentPage = 0;
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      // Reset pagination saat reload data
      transaksiCurrentPage = 0;
      kegiatanCurrentPage = 0;
    });

    try {
      final results = await Future.wait([
        PemasukanService.instance.getAllPemasukan(),
        PengeluaranService.instance.getAllPengeluaran(),
        KegiatanService.instance.getAll().first,
      ]);

      pemasukanList = results[0] as List<Pemasukan>;
      pengeluaranList = results[1] as List<Pengeluaran>;
      kegiatanList = results[2] as List<KegiatanModel>;

      _calculateData();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _calculateData() {
    // Reset
    totalPemasukan = 0;
    totalPengeluaran = 0;
    totalAnggaranKegiatan = 0;
    pemasukanPerKategori.clear();
    pengeluaranPerKategori.clear();
    monthlyData.clear();

    // Hitung pemasukan
    for (var p in pemasukanList) {
      totalPemasukan += p.nominal;
      pemasukanPerKategori[p.kategori] =
          (pemasukanPerKategori[p.kategori] ?? 0) + p.nominal;

      // Monthly data
      final month = DateFormat('MMM yyyy', 'id').format(p.tanggal);
      monthlyData[month] = (monthlyData[month] ?? 0) + p.nominal;
    }

    // Hitung pengeluaran
    for (var p in pengeluaranList) {
      totalPengeluaran += p.nominal;
      pengeluaranPerKategori[p.kategori] =
          (pengeluaranPerKategori[p.kategori] ?? 0) + p.nominal;

      // Monthly data
      final month = DateFormat('MMM yyyy', 'id').format(p.tanggal);
      monthlyData[month] = (monthlyData[month] ?? 0) - p.nominal;
    }

    // Hitung anggaran kegiatan
    for (var k in kegiatanList) {
      totalAnggaranKegiatan += k.anggaran;
      if (k.anggaran > 0) {
        pengeluaranPerKategori['Kegiatan'] =
            (pengeluaranPerKategori['Kegiatan'] ?? 0) + k.anggaran;
      }
    }

    // Total pengeluaran termasuk anggaran
    final totalPengeluaranAll = totalPengeluaran + totalAnggaranKegiatan;
    saldo = totalPemasukan - totalPengeluaranAll;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Dashboard Keuangan"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    _buildSummarySection(),
                    const SizedBox(height: 20),

                    // Chart Bulanan
                    _buildMonthlyChart(),
                    const SizedBox(height: 20),

                    // Kategori Breakdown
                    _buildKategoriBreakdown(),
                    const SizedBox(height: 20),

                    // Transaksi Terbaru
                    _buildTransaksiTerbaru(),
                    const SizedBox(height: 20),

                    // Anggaran Kegiatan
                    _buildAnggaranKegiatan(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          StatsCardShimmer(),
          SizedBox(height: 16),
          StatsCardShimmer(),
          SizedBox(height: 16),
          StatsCardShimmer(),
          SizedBox(height: 16),
          StatsCardShimmer(),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final totalPengeluaranAll = totalPengeluaran + totalAnggaranKegiatan;

    return Column(
      children: [
        // Saldo Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: saldo >= 0
                  ? [
                      AppStyles.primaryColor.withOpacity(0.8),
                      AppStyles.primaryColor,
                    ]
                  : [Colors.orange.shade400, Colors.orange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (saldo >= 0
                        ? AppStyles.primaryColor
                        : Colors.orange.shade400)
                    .withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Saldo Saat Ini",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _formatCurrency(saldo),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (saldo < 0)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Saldo Defisit",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Pemasukan & Pengeluaran Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: "Total Pemasukan",
                value: totalPemasukan,
                icon: Icons.arrow_circle_up,
                color: Colors.green,
                count: pemasukanList.length,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: "Total Pengeluaran",
                value: totalPengeluaranAll,
                icon: Icons.arrow_circle_down,
                color: Colors.red,
                count: pengeluaranList.length + kegiatanList.length,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Detail Breakdown
        Row(
          children: [
            Expanded(
              child: _buildSmallStatCard(
                title: "Pengeluaran Rutin",
                value: totalPengeluaran,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallStatCard(
                title: "Anggaran Kegiatan",
                value: totalAnggaranKegiatan,
                color: Colors.orange.shade400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "$count transaksi",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard({
    required String title,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              fontSize: 16,
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

  Widget _buildMonthlyChart() {
    if (monthlyData.isEmpty) {
      return _buildEmptyCard("Belum ada data untuk grafik bulanan");
    }

    // Ambil 6 bulan terakhir
    final sortedEntries = monthlyData.entries.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMM yyyy', 'id').parse(a.key);
          final dateB = DateFormat('MMM yyyy', 'id').parse(b.key);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

    final last6Months = sortedEntries.length > 6
        ? sortedEntries.sublist(sortedEntries.length - 6)
        : sortedEntries;

    final maxValue = last6Months.fold<int>(
      0,
      (max, entry) => entry.value.abs() > max ? entry.value.abs() : max,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppStyles.primaryColor, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Grafik Keuangan 6 Bulan Terakhir",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue.toDouble() * 1.2,
                minY: -(maxValue.toDouble() * 1.2),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < last6Months.length) {
                          final month = last6Months[value.toInt()].key;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              month.substring(0, 3),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCompactCurrency(value.toInt()),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  last6Months.length,
                  (index) {
                    final value = last6Months[index].value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value.toDouble(),
                          color: value >= 0 ? Colors.green : Colors.red,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                            bottom: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Surplus", Colors.green),
              const SizedBox(width: 20),
              _buildLegendItem("Defisit", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildKategoriBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pemasukan per Kategori
        if (pemasukanPerKategori.isNotEmpty) ...[
          _buildKategoriCard(
            title: "Pemasukan per Kategori",
            icon: Icons.category,
            color: Colors.green,
            data: pemasukanPerKategori,
          ),
          const SizedBox(height: 16),
        ],

        // Pengeluaran per Kategori
        if (pengeluaranPerKategori.isNotEmpty)
          _buildKategoriCard(
            title: "Pengeluaran per Kategori",
            icon: Icons.category_outlined,
            color: Colors.red,
            data: pengeluaranPerKategori,
          ),
      ],
    );
  }

  Widget _buildKategoriCard({
    required String title,
    required IconData icon,
    required Color color,
    required Map<String, int> data,
  }) {
    final sortedData = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = data.values.fold<int>(0, (sum, value) => sum + value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedData.map((entry) {
            final percentage = (entry.value / total * 100).round();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatCurrency(entry.value),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: color.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$percentage%",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransaksiTerbaru() {
    // Gabungkan semua transaksi
    final List<Map<String, dynamic>> allTransactions = [];

    for (var p in pemasukanList) {
      allTransactions.add({
        'nama': p.nama,
        'kategori': p.kategori,
        'nominal': p.nominal,
        'tanggal': p.tanggal,
        'tipe': 'pemasukan',
      });
    }

    for (var p in pengeluaranList) {
      allTransactions.add({
        'nama': p.nama,
        'kategori': p.kategori,
        'nominal': p.nominal,
        'tanggal': p.tanggal,
        'tipe': 'pengeluaran',
      });
    }

    // Sort by date
    allTransactions.sort((a, b) =>
        (b['tanggal'] as DateTime).compareTo(a['tanggal'] as DateTime));

    // Pagination
    final totalPages = (allTransactions.length / itemsPerPage).ceil();
    final startIndex = transaksiCurrentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage > allTransactions.length)
        ? allTransactions.length
        : startIndex + itemsPerPage;
    final paginatedTransactions = allTransactions.sublist(startIndex, endIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppStyles.primaryColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Transaksi Terbaru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (allTransactions.isNotEmpty)
                      Text(
                        "Total ${allTransactions.length} transaksi",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (paginatedTransactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Belum ada transaksi",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else ...[
            ...paginatedTransactions.map((t) => _buildTransactionItem(
                  nama: t['nama'],
                  kategori: t['kategori'],
                  nominal: t['nominal'],
                  tanggal: t['tanggal'],
                  isPemasukan: t['tipe'] == 'pemasukan',
                )),
            if (totalPages > 1) ...[
              const SizedBox(height: 8),
              _buildPaginationControls(
                currentPage: transaksiCurrentPage,
                totalPages: totalPages,
                onPageChanged: (page) {
                  setState(() {
                    transaksiCurrentPage = page;
                  });
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String nama,
    required String kategori,
    required int nominal,
    required DateTime tanggal,
    required bool isPemasukan,
  }) {
    final color = isPemasukan ? Colors.green : Colors.red;

    return InkWell(
      onTap: () => _showTransactionDetail(
        nama: nama,
        kategori: kategori,
        nominal: nominal,
        tanggal: tanggal,
        isPemasukan: isPemasukan,
      ),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.label_outline,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kategori,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(nominal),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM', 'id').format(tanggal),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetail({
    required String nama,
    required String kategori,
    required int nominal,
    required DateTime tanggal,
    required bool isPemasukan,
  }) {
    final color = isPemasukan ? Colors.green : Colors.red;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPemasukan ? "Pemasukan" : "Pengeluaran",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(nominal),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.description, "Nama", nama),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.category, "Kategori", kategori),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.calendar_today,
              "Tanggal",
              DateFormat('EEEE, dd MMMM yyyy', 'id').format(tanggal),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppStyles.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showKegiatanDetail(KegiatanModel kegiatan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Anggaran Kegiatan",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(kegiatan.anggaran),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow(
                Icons.event, "Nama Kegiatan", kegiatan.namaKegiatan),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.category, "Kategori", kegiatan.kategori),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.calendar_today,
              "Tanggal",
              DateFormat('EEEE, dd MMMM yyyy', 'id')
                  .format(DateTime.parse(kegiatan.tanggal)),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.place, "Lokasi", kegiatan.lokasi),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.person,
              "Penanggung Jawab",
              kegiatan.penanggungJawab,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.description,
              "Deskripsi",
              kegiatan.deskripsi,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnggaranKegiatan() {
    final kegiatanWithBudget =
        kegiatanList.where((k) => k.anggaran > 0).toList();

    if (kegiatanWithBudget.isEmpty) {
      return _buildEmptyCard("Belum ada kegiatan dengan anggaran");
    }

    // Sort by budget
    kegiatanWithBudget.sort((a, b) => b.anggaran.compareTo(a.anggaran));

    // Pagination
    final totalPages = (kegiatanWithBudget.length / itemsPerPage).ceil();
    final startIndex = kegiatanCurrentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage > kegiatanWithBudget.length)
        ? kegiatanWithBudget.length
        : startIndex + itemsPerPage;
    final paginatedKegiatan = kegiatanWithBudget.sublist(startIndex, endIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: Colors.orange.shade700, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Anggaran Kegiatan Terbaru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total ${kegiatanWithBudget.length} kegiatan",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Hal ${kegiatanCurrentPage + 1}/$totalPages",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...paginatedKegiatan.map((k) {
            return InkWell(
              onTap: () => _showKegiatanDetail(k),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.event,
                        color: Colors.orange.shade700,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            k.namaKegiatan,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.category_outlined,
                                  size: 12, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  k.kategori,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatCurrency(k.anggaran),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM', 'id')
                              .format(DateTime.parse(k.tanggal)),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          if (totalPages > 1) ...[
            const SizedBox(height: 8),
            _buildPaginationControls(
              currentPage: kegiatanCurrentPage,
              totalPages: totalPages,
              onPageChanged: (page) {
                setState(() {
                  kegiatanCurrentPage = page;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaginationControls({
    required int currentPage,
    required int totalPages,
    required Function(int) onPageChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          InkWell(
            onTap:
                currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: currentPage > 0
                    ? AppStyles.primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left,
                    size: 18,
                    color:
                        currentPage > 0 ? Colors.white : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Prev",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          currentPage > 0 ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Page Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppStyles.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Halaman ${currentPage + 1}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryColor,
                  ),
                ),
                Text(
                  " / $totalPages",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Next Button
          InkWell(
            onTap: currentPage < totalPages - 1
                ? () => onPageChanged(currentPage + 1)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: currentPage < totalPages - 1
                    ? AppStyles.primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: currentPage < totalPages - 1
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: currentPage < totalPages - 1
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatCompactCurrency(int amount) {
    if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }
}
