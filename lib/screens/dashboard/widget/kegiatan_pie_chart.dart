import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/kegiatan.dart';

class KegiatanPieChart extends StatefulWidget {
  final List<KegiatanModel> data;

  const KegiatanPieChart({super.key, required this.data});

  @override
  State<KegiatanPieChart> createState() => _KegiatanPieChartState();
}



class _KegiatanPieChartState extends State<KegiatanPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final Map<String, int> kategoriCount = {};

    for (var k in widget.data) {
      kategoriCount[k.kategori] = (kategoriCount[k.kategori] ?? 0) + 1;
    }

    final total = widget.data.length.toDouble();

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              _touchedIndex =
                  response?.touchedSection?.touchedSectionIndex ?? -1;
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
            badgeWidget: isTouched
                ? _Pie_Tooltip(title: entry.key, value: entry.value)
                : null,
            badgePositionPercentageOffset: 1.3,
          );
        }),
      ),
    );
  }
}

class _Pie_Tooltip extends StatelessWidget {
  final String title;
  final int value;

  const _Pie_Tooltip({
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
