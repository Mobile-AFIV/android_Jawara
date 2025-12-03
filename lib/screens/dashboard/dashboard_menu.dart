import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardMenu extends StatelessWidget {
  const DashboardMenu({super.key});

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
          children: [
            // === TOTAL KEGIATAN ===
            _totalKegiatanCard(),

            const SizedBox(height: 20),

            // === PIE CHART KATEGORI ===
            _kegiatanPerKategori(),

            const SizedBox(height: 20),

            // === KEGIATAN BERDASARKAN WAKTU ===
            _kegiatanBerdasarkanWaktu(),

            const SizedBox(height: 20),

            // === PENANGGUNG JAWAB TERBANYAK ===
            _pjTerbanyak(),

            const SizedBox(height: 20),

            // === BAR CHART PER BULAN ===
            _kegiatanPerBulan(),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// ========================== WIDGETS ===============================
// ==================================================================

Widget _totalKegiatanCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: _boxDecoration(Colors.lightBlue.shade100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎉 Total Kegiatan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          "3",
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
        const Text("Jumlah seluruh event yang sudah ada"),
      ],
    ),
  );
}

Widget _kegiatanPerKategori() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: _boxDecoration(Colors.green.shade100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📁 Kegiatan per Kategori",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 33,
                  color: Colors.blue,
                  title: "33%",
                  radius: 45,
                ),
                PieChartSectionData(
                  value: 33,
                  color: Colors.green,
                  title: "33%",
                  radius: 45,
                ),
                PieChartSectionData(
                  value: 33,
                  color: Colors.purple,
                  title: "33%",
                  radius: 45,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 12,
          children: [
            _legend("Komunitas & Sosial", Colors.blue),
            _legend("Kebersihan & Keamanan", Colors.green),
            _legend("Keagamaan", Colors.purple),
          ],
        ),
      ],
    ),
  );
}

Widget _kegiatanBerdasarkanWaktu() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: _boxDecoration(Colors.yellow.shade100),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "⏰ Kegiatan berdasarkan Waktu",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text("Sudah Lewat: 2"),
        Text("Hari Ini: 1"),
        Text("Akan Datang: 0"),
      ],
    ),
  );
}

Widget _pjTerbanyak() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: _boxDecoration(Colors.purple.shade100),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "👤 Penanggung Jawab Terbanyak",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _pjListItem("Pak", 1),
        _pjListItem("PAK RT", 1),
        _pjListItem("Ketua Suku", 1),
      ],
    ),
  );
}

Widget _kegiatanPerBulan() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: _boxDecoration(Colors.pink.shade100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📅 Kegiatan per Bulan (Tahun Ini)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const months = [
                        "", // dummy index 0
                        "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
                        "Jul", "Agu", "Sep", "Okt", "Nov", "Des",
                      ];

                      return Text(
                        value.toInt() >= 1 && value.toInt() <= 12
                            ? months[value.toInt()]
                            : "",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5)]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3)]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 7)]),
                BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 3)]),
                BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 1)]),
                BarChartGroupData(x: 12, barRods: [BarChartRodData(toY: 1)]),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// =================================================================
// ======================== HELPER WIDGET ==========================
// =================================================================

BoxDecoration _boxDecoration(Color bgColor) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 4),
        blurRadius: 10,
      )
    ],
  );
}

class _legend extends StatelessWidget {
  final String label;
  final Color color;
  const _legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _pjListItem extends StatelessWidget {
  final String name;
  final int jumlah;
  const _pjListItem(this.name, this.jumlah);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(name)),
        Text(jumlah.toString()),
      ],
    );
  }
}
