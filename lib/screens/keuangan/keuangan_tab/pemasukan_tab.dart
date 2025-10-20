import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/kategori_iuran_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/pemasukan_lain_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/pemasukan_tagihan_section.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PemasukanTab extends StatefulWidget {
  const PemasukanTab({super.key});

  @override
  State<PemasukanTab> createState() => _PemasukanTabState();
}

class _PemasukanTabState extends State<PemasukanTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60 + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingSection(
              headingText: "Kelola daftar kategori iuran anda",
              subHeadingText: "Kategori Iuran",
              lainnyaOnPressed: () => context.pushNamed('kategori_iuran'),
            ),
            kategoriIuranSection(),
            HeadingSection(
              headingText: "Kelola tagihan iuran dari para keluarga",
              subHeadingText: "Tagihan Iuran",
              lainnyaOnPressed: () => context.pushNamed('pemasukan_tagihan'),
            ),
            tagihanIuranSection(),
            HeadingSection(
              headingText: "Kelola pemasukan lainnya",
              subHeadingText: "Pemasukan Lain",
              lainnyaOnPressed: () => context.pushNamed('pemasukan_lain'),
            ),
            pemasukanLainSection(),
            // Container(
            //   height: 200,
            //   width: double.maxFinite,
            //   color: Colors.green.shade100,
            //   child: Center(child: Text("Body")),
            // ),
          ],
        ),
      ),
    );
  }

  // ----------------- SECTION KATEGORI IURAN -----------------
  Widget kategoriIuranSection() {
    const int limitItemShowed = 3;
    final kategoriList = PemasukanSectionData.kategoriIuranData;
    final topKategori = kategoriList.take(limitItemShowed).toList();

    Widget kategoriItem(Map<String, dynamic> json) {
      final KategoriIuranData kategori = KategoriIuranData.fromJson(json);

      return Container(
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding:
            topKategori.length != 1 && !(topKategori.length < limitItemShowed)
                ? const EdgeInsets.only(bottom: 8)
                : null,
        decoration: BoxDecoration(
          border:
              topKategori.length != 1 && !(topKategori.length < limitItemShowed)
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
              height: 56,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width - 148,
                        ),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          kategori.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        kategori.jenis,
                        style: const TextStyle(
                          color: AppStyles.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp${kategori.nominal},00",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
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
            topKategori.length,
            (index) {
              return kategoriItem(topKategori[index]);
            },
          ),
        ),
        if (topKategori.length != 1 && !(topKategori.length < limitItemShowed))
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
        if (topKategori.length != 1 && !(topKategori.length < limitItemShowed))
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                "+${kategoriList.length - limitItemShowed + 1} lainnya",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // ----------------- SECTION TAGIHAN IURAN -----------------
  Widget tagihanIuranSection() {
    const int limitItemShowed = 3;
    final tagihanList = PemasukanSectionData.tagihanIuranData;
    final topTagihan = tagihanList.take(limitItemShowed).toList();

    Widget tagihanIuranItem(Map<String, dynamic> json) {
      final TagihanKeluarga tagihanKeluarga = TagihanKeluarga.fromJson(json);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              overflow: TextOverflow.ellipsis,
              tagihanKeluarga.nama,
              style: const TextStyle(
                fontSize: 16,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 1),
                SizedBox(
                  height: 14,
                  width: 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: (tagihanKeluarga.statusKeluarga ==
                              StatusKeluarga.aktif)
                          ? AppStyles.successColor
                          : AppStyles.errorColor,
                      borderRadius: BorderRadiusGeometry.circular(50),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tagihanKeluarga.statusKeluarga.label,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        (tagihanKeluarga.statusKeluarga == StatusKeluarga.aktif)
                            ? AppStyles.successColor
                            : AppStyles.errorColor,
                  ),
                ),
                // Expanded(child: const SizedBox(width: 32)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(width: 32),
                SizedBox(
                  height: 16,
                  width: 14,
                  child: Icon(
                    Icons.date_range,
                    color: Colors.grey.shade500,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Iuran ${tagihanKeluarga.kategori}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rp${tagihanKeluarga.nominal},00",
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                    decoration:
                        (tagihanKeluarga.statusTagihan == StatusTagihan.ditolak)
                            ? TextDecoration.lineThrough
                            : null,
                    decorationColor: Colors.grey.shade500,
                  ),
                ),
                const Expanded(child: const SizedBox(width: 32)),
                // const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(4),
                    border: Border.all(
                      color:
                          (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                              ? AppStyles.warningSurfaceColor
                              : Colors.grey.shade500,
                    ),
                  ),
                  child: Text(
                    tagihanKeluarga.statusTagihan.label,
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          (tagihanKeluarga.statusTagihan == StatusTagihan.belum)
                              ? AppStyles.warningOnSurfaceColor
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: List.generate(
            topTagihan.length,
            (index) {
              return tagihanIuranItem(topTagihan[index]);
            },
          ),
        ),
        if (topTagihan.length != 1 && !(topTagihan.length < limitItemShowed))
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
        if (topTagihan.length != 1 && !(topTagihan.length < limitItemShowed))
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                "+${tagihanList.length - limitItemShowed + 1} lainnya",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // ----------------- SECTION PEMASUKAN LAIN -----------------
  Widget pemasukanLainSection() {
    const int limitItemShowed = 3;
    final pemasukanLainList = PemasukanSectionData.pemasukanLainData;
    final topPemasukanLain = pemasukanLainList.take(limitItemShowed).toList();

    String dateParse(String input) {
      final parser = DateFormat('d MMMM yyyy', 'id');
      final date = parser.parse(input);

      final String output = DateFormat('EEEE, d MMM yyyy', 'id').format(date);

      return output;
    }

    Widget tagihanIuranItem(Map<String, dynamic> json) {
      final PemasukanLainData pemasukanLain = PemasukanLainData.fromJson(json);

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
                          pemasukanLain.jenisPemasukan,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          pemasukanLain.nama,
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
                              "Rp${pemasukanLain.nominal},00",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              dateParse(pemasukanLain.tanggal),
                              // pemasukanLain.tanggal,
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
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                "+${pemasukanLainList.length - limitItemShowed + 1} lainnya",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
