import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/models/kegiatan.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/dashboard/widget/kegiatan_pie_chart.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/kegiatan_service.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  int _touchedIndex = -1;
  int _totalWarga = 0;
  int _totalKeluarga = 0;
  int _totalRumahAktif = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============= SECTION KEGIATAN =============
            _buildSectionHeader(
              icon: Icons.event,
              title: "Dashboard Kegiatan",
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildKegiatanSection(),

            const SizedBox(height: 24),

            // ============= SECTION KEUANGAN =============
            _buildSectionHeader(
              icon: Icons.account_balance_wallet,
              title: "Dashboard Keuangan",
              color: Colors.green,
              onTap: () => context.pushNamed('dashboard_keuangan'),
            ),
            const SizedBox(height: 12),
            _buildKeuanganSection(),

            const SizedBox(height: 24),

            // ============= SECTION WARGA =============
            _buildSectionHeader(
              icon: Icons.people,
              title: "Dashboard Warga",
              color: Colors.orange,
              // onTap: () {
              //   // Navigate to warga dashboard when ready
              // },
            ),
            const SizedBox(height: 12),
            _buildWargaSection(),

            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  // ============= KEGIATAN SECTION =============
  Widget _buildKegiatanSection() {
    return StreamBuilder<List<KegiatanModel>>(
      stream: KegiatanService.instance.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: StatsCardShimmer(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyCard("Belum ada data kegiatan");
        }

        final data = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// KOLOM KIRI
                SizedBox(
                  width: constraints.maxWidth * 0.48,
                  child: Column(
                    children: [
                      _totalKegiatanCard(data),
                      const SizedBox(height: 12),
                      _kegiatanBerdasarkanWaktu(data),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                /// KOLOM KANAN
                SizedBox(
                  width: constraints.maxWidth * 0.48,
                  child: _kegiatanPerKategori(data),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= TOTAL KEGIATAN =================
  Widget _totalKegiatanCard(List<KegiatanModel> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(Colors.lightBlue.shade100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Kegiatan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            data.length.toString(),
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
          const Text("Jumlah seluruh kegiatan"),
        ],
      ),
    );
  }

  // ================= WAKTU KEGIATAN =================
  Widget _kegiatanBerdasarkanWaktu(List<KegiatanModel> data) {
    final now = DateTime.now();
    int lewat = 0, hariIni = 0, akanDatang = 0;

    for (var k in data) {
      final tgl = DateTime.parse(k.tanggal);
      if (tgl.isBefore(DateTime(now.year, now.month, now.day))) {
        lewat++;
      } else if (tgl.year == now.year &&
          tgl.month == now.month &&
          tgl.day == now.day) {
        hariIni++;
      } else {
        akanDatang++;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(Colors.yellow.shade100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kegiatan Berdasarkan Waktu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text("Sudah Lewat : $lewat"),
          Text("Hari Ini     : $hariIni"),
          Text("Akan Datang  : $akanDatang"),
        ],
      ),
    );
  }

  // ================= PIE CHART PER KATEGORI =================
  Widget _kegiatanPerKategori(List<KegiatanModel> data) {
    final Map<String, int> kategoriCount = {};

    for (var k in data) {
      kategoriCount[k.kategori] = (kategoriCount[k.kategori] ?? 0) + 1;
    }

    final total = data.length.toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(Colors.green.shade100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kegiatan per Kategori",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: KegiatanPieChart(data: data),
          ),
        ],
      ),
    );
  }

  // ============= KEUANGAN SECTION =============
  Widget _buildKeuanganSection() {
    return FutureBuilder<List<Pemasukan>>(
      future: PemasukanService.instance.getAllPemasukan(),
      builder: (context, pemasukanSnapshot) {
        return FutureBuilder<List<Pengeluaran>>(
          future: PengeluaranService.instance.getAllPengeluaran(),
          builder: (context, pengeluaranSnapshot) {
            return StreamBuilder<List<KegiatanModel>>(
              stream: KegiatanService.instance.getAll(),
              builder: (context, kegiatanSnapshot) {
                if (pemasukanSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    pengeluaranSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    kegiatanSnapshot.connectionState ==
                        ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: StatsCardShimmer(),
                  );
                }

                final pemasukanList = pemasukanSnapshot.data ?? [];
                final pengeluaranList = pengeluaranSnapshot.data ?? [];
                final kegiatanList = kegiatanSnapshot.data ?? [];

                // Total pemasukan
                int totalPemasukan = 0;
                for (var p in pemasukanList) {
                  totalPemasukan += p.nominal;
                }

                // Total pengeluaran (dari pengeluaran + anggaran kegiatan)
                int totalPengeluaran = 0;
                for (var p in pengeluaranList) {
                  totalPengeluaran += p.nominal;
                }
                for (var k in kegiatanList) {
                  totalPengeluaran += k.anggaran;
                }

                // Saldo
                int saldo = totalPemasukan - totalPengeluaran;

                // Pemasukan terbaru (3 terakhir)
                final pemasukanTerbaru = pemasukanList.take(3).toList();

                // Pengeluaran terbaru (3 terakhir - gabungan pengeluaran + kegiatan)
                final List<Map<String, dynamic>> allPengeluaran = [];
                for (var p in pengeluaranList) {
                  allPengeluaran.add({
                    'nama': p.nama,
                    'nominal': p.nominal,
                    'tanggal': p.tanggal,
                    'tipe': 'pengeluaran',
                  });
                }
                for (var k in kegiatanList) {
                  if (k.anggaran > 0) {
                    allPengeluaran.add({
                      'nama': 'Anggaran: ${k.namaKegiatan}',
                      'nominal': k.anggaran,
                      'tanggal': DateTime.parse(k.tanggal),
                      'tipe': 'kegiatan',
                    });
                  }
                }
                // Sort berdasarkan tanggal terbaru
                allPengeluaran.sort((a, b) => (b['tanggal'] as DateTime)
                    .compareTo(a['tanggal'] as DateTime));
                final pengeluaranTerbaru = allPengeluaran.take(3).toList();

                return Column(
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: "Pemasukan",
                            value: totalPemasukan,
                            icon: Icons.arrow_circle_up,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            title: "Pengeluaran",
                            value: totalPengeluaran,
                            icon: Icons.arrow_circle_down,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSaldoCard(saldo),
                    const SizedBox(height: 16),

                    // Transaksi Terbaru
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTransaksiTerbaru(
                            title: "💰 Pemasukan Terbaru",
                            color: Colors.green.shade100,
                            items: pemasukanTerbaru
                                .map((p) => {
                                      'nama': p.nama,
                                      'nominal': p.nominal,
                                      'tanggal': p.tanggal,
                                    })
                                .toList(),
                            isEmpty: pemasukanTerbaru.isEmpty,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTransaksiTerbaru(
                            title: "💸 Pengeluaran Terbaru",
                            color: Colors.red.shade100,
                            items: pengeluaranTerbaru,
                            isEmpty: pengeluaranTerbaru.isEmpty,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(color.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(value),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaldoCard(int saldo) {
    final isPositive = saldo >= 0;
    final color = isPositive ? Colors.blue : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(color.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                "Saldo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(saldo),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (!isPositive)
            const Text(
              "⚠️ Saldo defisit",
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
        ],
      ),
    );
  }

  Widget _buildTransaksiTerbaru({
    required String title,
    required Color color,
    required List<Map<String, dynamic>> items,
    required bool isEmpty,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (isEmpty)
            const Text(
              "Belum ada transaksi",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(item['nominal']),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['tanggal'] is DateTime
                                ? DateFormat('dd/MM/yy').format(item['tanggal'])
                                : DateFormat('dd/MM/yy')
                                    .format(item['tanggal']),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (items.indexOf(item) < items.length - 1)
                        const Divider(height: 16),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Future<void> _loadStatistics() async {
    try {
      // Load Total Warga
      final wargaSnapshot =
          await FirebaseFirestore.instance.collection('warga').get();

      // Load Total Keluarga (unique families)
      final wargaData = wargaSnapshot.docs.map((doc) => doc.data()).toList();
      final uniqueFamilies = wargaData
          .map((data) => data['family'] as String?)
          .where((family) => family != null && family.isNotEmpty)
          .toSet();

      // Load Total Rumah Aktif (status "Ditempati")
      final rumahSnapshot = await FirebaseFirestore.instance
          .collection('rumah_warga')
          .where('status', isEqualTo: 'Ditempati')
          .get();

      setState(() {
        _totalWarga = wargaSnapshot.docs.length;
        _totalKeluarga = uniqueFamilies.length;
        _totalRumahAktif = rumahSnapshot.docs.length;
      });
    } catch (e) {
      // Silently fail, keep counts at 0
      setState(() {
        _totalWarga = 0;
        _totalKeluarga = 0;
        _totalRumahAktif = 0;
      });
    }
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============= WARGA SECTION =============
  Widget _buildWargaSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(width: 8),
                Text(
                  'Statistik Singkat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              'Total Warga',
              _totalWarga.toString(),
              Icons.people,
              const Color(0xFF4A90E2),
            ),
            const Divider(height: 24),
            _buildStatItem(
              'Keluarga Terdaftar',
              _totalKeluarga.toString(),
              Icons.family_restroom,
              const Color(0xFF7B68EE),
            ),
            const Divider(height: 24),
            _buildStatItem(
              'Rumah Aktif',
              _totalRumahAktif.toString(),
              Icons.home,
              const Color(0xFF50C878),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: _boxDecoration(Colors.grey.shade100),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ================= HELPER =================
  BoxDecoration _boxDecoration(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ],
    );
  }
}
