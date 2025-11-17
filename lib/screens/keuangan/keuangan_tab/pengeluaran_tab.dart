import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pengeluaran_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pengeluaran_section/pengeluaran_daftar_section.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PengeluaranTab extends StatefulWidget {
  const PengeluaranTab({super.key});

  @override
  State<PengeluaranTab> createState() => _PengeluaranTabState();
}

class _PengeluaranTabState extends State<PengeluaranTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60 + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingSection(
              headingText: "Kelola daftar pengeluaran anda",
              subHeadingText: "Pengeluaran Daftar",
              lainnyaOnPressed: () => context.pushNamed('pengeluaran_daftar'),
            ),
            pengeluaranSection(),
          ],
        ),
      ),
    );
  }

  // ----------------- SECTION PENGELUARAN -----------------
  Widget pengeluaranSection() {
    const int limitItemShowed = 3;
    final pengeluaranList = PengeluaranSectionData.pengeluaranData;
    final topPemasukanLain = pengeluaranList.take(limitItemShowed).toList();

    String dateParse(String input) {
      final parser = DateFormat('d MMMM yyyy', 'id');
      final date = parser.parse(input);

      final String output = DateFormat('EEEE, d MMM yyyy', 'id').format(date);

      return output;
    }

    Widget tagihanIuranItem(Map<String, dynamic> json) {
      final PengeluaranData pengeluaran = PengeluaranData.fromJson(json);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: topPemasukanLain.length != 1 &&
              !(topPemasukanLain.length < limitItemShowed)
              ? Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          )
              : null,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              color: AppStyles.primaryColor,
              width: 4,
              height: 80,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          pengeluaran.jenisPengeluaran,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          pengeluaran.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp${pengeluaran.nominal},00",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              dateParse(pengeluaran.tanggal),
                              // pengeluaran.tanggal,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: List.generate(
            topPemasukanLain.length,
                (index) {
              return tagihanIuranItem(
                topPemasukanLain[index],
              );
            },
          ),
        ),
        if (topPemasukanLain.length != 1 &&
            !(topPemasukanLain.length < limitItemShowed))
          Positioned.fill(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withValues(alpha: .0), Colors.white],
                  begin: Alignment.topCenter,
                  end: const Alignment(0, 0.65),
                ),
              ),
            ),
          ),
        if (topPemasukanLain.length != 1 &&
            !(topPemasukanLain.length < limitItemShowed))
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () => context.pushNamed('pengeluaran_daftar'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  "+${pengeluaranList.length - limitItemShowed + 1} lainnya",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
