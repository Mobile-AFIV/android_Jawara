import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/kategori_iuran_section.dart';
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
            subHeadingText: "Pemasukan Tagihan",
            lainnyaOnPressed: () => context.pushNamed('pemasukan_tagihan'),
          ),
          Container(
            height: 200,
            width: double.maxFinite,
            color: Colors.green.shade100,
            child: Center(child: Text("Body")),
          ),

          HeadingSection(
            headingText: "Kelola pemasukan lainnya",
            subHeadingText: "Pemasukan Lain",
            lainnyaOnPressed: () => context.pushNamed('pemasukan_lain'),
          ),
          Container(
            height: 200,
            width: double.maxFinite,
            color: Colors.green.shade100,
            child: Center(child: Text("Body")),
          ),
        ],
      ),
    );
  }

  // ----------------- SECTION KATEGORI IURAN -----------------
  Widget kategoriIuranSection() {
    final int limitItemShowed = 3;
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
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(fontSize: 16),
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
              padding: EdgeInsets.only(bottom: 20),
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                "+${kategoriList.length - limitItemShowed + 1} lainnya",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}