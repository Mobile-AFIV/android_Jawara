import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/kategori_iuran.dart';
import 'package:jawara_pintar/models/tagihan_iuran.dart';
import 'package:jawara_pintar/models/pemasukan.dart';
import 'package:jawara_pintar/screens/keuangan/widget/body_section_info.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/kategori_iuran_service.dart';
import 'package:jawara_pintar/services/tagihan_iuran_service.dart';
import 'package:jawara_pintar/services/pemasukan_service.dart';
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

    Widget kategoriItem({
      required KategoriIuran kategori,
      required List<KategoriIuran> topKategori,
    }) {
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
                            fontWeight: FontWeight.bold,
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

    return FutureBuilder<List<KategoriIuran>>(
        future: KategoriIuranService.instance.getAllKategori(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: KategoriItemShimmer(),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return BodySectionInfo(
              backgroundColor: AppStyles.errorColor.withValues(alpha: 0.1),
              textInfo: snapshot.error.toString(),
            );
          }

          if (!snapshot.hasData && snapshot.data == null) {
            return BodySectionInfo(
              backgroundColor: AppStyles.primaryColor.withValues(alpha: 0.1),
              textInfo: "Data kategori tidak ditemukan.",
            );
          }

          if (snapshot.data!.isEmpty) {
            return BodySectionInfo(
              backgroundColor: AppStyles.primaryColor.withValues(alpha: 0.1),
              textInfo: "Tidak ada kategori,\ncobalah untuk membuatnya",
            );
          }

          final kategoriList = snapshot.data!;
          final topKategori = kategoriList.take(limitItemShowed).toList();

          return Stack(
            children: [
              Column(
                children: List.generate(
                  topKategori.length,
                  (index) {
                    return kategoriItem(
                      kategori: topKategori[index],
                      topKategori: topKategori,
                    );
                  },
                ),
              ),
              if (topKategori.length != 1 &&
                  !(topKategori.length < limitItemShowed))
                Positioned.fill(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: .0),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: const Alignment(0, 0.65),
                      ),
                    ),
                  ),
                ),
              if (topKategori.length != 1 &&
                  !(topKategori.length < limitItemShowed))
                Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () => context.pushNamed('kategori_iuran'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.sizeOf(context).width,
                      child: Text(
                        "+${kategoriList.length - limitItemShowed + 1} lainnya",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }

  // ----------------- SECTION TAGIHAN IURAN -----------------
  Widget tagihanIuranSection() {
    const int limitItemShowed = 3;

    return FutureBuilder<List<TagihanIuran>>(
      future: TagihanIuranService.instance.getTagihanWithFilter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TagihanItemShimmer(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tidak ada data tagihan',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        final tagihanList = snapshot.data!;
        final topTagihan = tagihanList.take(limitItemShowed).toList();

        Widget tagihanIuranItem(TagihanIuran tagihanIuran) {
          final statusColor = tagihanIuran.statusPembayaran ==
                  StatusPembayaran.diterima
              ? AppStyles.successColor
              : tagihanIuran.statusPembayaran == StatusPembayaran.belum
                  ? AppStyles.warningSurfaceColor
                  : tagihanIuran.statusPembayaran == StatusPembayaran.menunggu
                      ? Colors.orange
                      : Colors.grey.shade500;

          return InkWell(
            onTap: () => context.pushNamed(
              'detail_tagihan',
              pathParameters: {'tagihanId': tagihanIuran.id},
            ),
            child: Container(
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
                    tagihanIuran.namaKeluarga,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.grey.shade500,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Iuran ${tagihanIuran.kategoriIuran}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMMM yyyy', 'id').format(tagihanIuran.periode),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        ).format(tagihanIuran.nominal),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox(width: 32)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: statusColor.withOpacity(0.1),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          tagihanIuran.statusPembayaran.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            if (topTagihan.length != 1 &&
                !(topTagihan.length < limitItemShowed))
              Positioned.fill(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: .0),
                        Colors.white
                      ],
                      begin: Alignment.topCenter,
                      end: const Alignment(0, 0.65),
                    ),
                  ),
                ),
              ),
            if (topTagihan.length != 1 &&
                !(topTagihan.length < limitItemShowed))
              Positioned(
                bottom: 0,
                child: InkWell(
                  onTap: () => context.pushNamed('pemasukan_tagihan'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.sizeOf(context).width,
                    child: Text(
                      "+${tagihanList.length - limitItemShowed + 1} lainnya",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ----------------- SECTION PEMASUKAN LAIN -----------------
  Widget pemasukanLainSection() {
    const int limitItemShowed = 3;

    return FutureBuilder<List<Pemasukan>>(
      future: PemasukanService.instance.getAllPemasukan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ListItemShimmer(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tidak ada data pemasukan lain',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        final pemasukanLainList = snapshot.data!;
        final topPemasukanLain =
            pemasukanLainList.take(limitItemShowed).toList();

        Widget pemasukanLainItem(Pemasukan pemasukan) {
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
                              pemasukan.kategori,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppStyles.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              pemasukan.nama,
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
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(pemasukan.nominal),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  DateFormat('EEEE, d MMM yyyy', 'id')
                                      .format(pemasukan.tanggal),
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
                  return pemasukanLainItem(
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
                      colors: [
                        Colors.white.withValues(alpha: .0),
                        Colors.white
                      ],
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
                  onTap: () => context.pushNamed('pemasukan_lain'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.sizeOf(context).width,
                    child: Text(
                      "+${pemasukanLainList.length - limitItemShowed + 1} lainnya",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
