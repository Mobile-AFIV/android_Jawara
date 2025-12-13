import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/kegiatan.dart';
import 'package:jawara_pintar/services/kegiatan_service.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({super.key});

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  int _touchedIndex = -1;

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
      body: StreamBuilder<List<KegiatanModel>>(
        stream: KegiatanService.instance.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data kegiatan"));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ================= KOLOM KIRI =================
                      SizedBox(
                        width: constraints.maxWidth * 0.45,
                        child: Column(
                          children: [
                            _totalKegiatanCard(data),
                            const SizedBox(height: 16),
                            _kegiatanBerdasarkanWaktu(data),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      /// ================= KOLOM KANAN =================
                      SizedBox(
                        width: constraints.maxWidth * 0.45,
                        child: _kegiatanPerKategori(data),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
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
            "🎉 Total Kegiatan",
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
            "⏰ Kegiatan Berdasarkan Waktu",
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
            "📁 Kegiatan per Kategori",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: List.generate(kategoriCount.length, (i) {
                  final entry = kategoriCount.entries.elementAt(i);
                  final isTouched = i == _touchedIndex;
                  final percent = ((entry.value / total) * 100).round();

                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    radius: isTouched ? 70 : 60,
                    color: Colors.primaries[i % Colors.primaries.length],
                    title: isTouched ? "" : "$percent%",
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    badgeWidget: isTouched
                        ? _PieTooltip(
                            title: entry.key,
                            value: entry.value,
                          )
                        : null,
                    badgePositionPercentageOffset: 1.3,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: kategoriCount.entries
                .map(
                  (e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.primaries[
                            kategoriCount.keys.toList().indexOf(e.key) %
                                Colors.primaries.length],
                      ),
                      const SizedBox(width: 6),
                      Text("${e.key} (${e.value})"),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
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

// ================= PIE TOOLTIP =================
class _PieTooltip extends StatelessWidget {
  final String title;
  final int value;

  const _PieTooltip({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "$title\n$value kegiatan",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
