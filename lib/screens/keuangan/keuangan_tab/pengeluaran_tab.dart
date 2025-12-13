import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/models/pengeluaran.dart';
import 'package:jawara_pintar/screens/keuangan/widget/heading_section.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/pengeluaran_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PengeluaranTab extends StatefulWidget {
  const PengeluaranTab({super.key});

  @override
  State<PengeluaranTab> createState() => _PengeluaranTabState();
}

class _PengeluaranTabState extends State<PengeluaranTab> {
  List<Pengeluaran> pengeluaranList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await PengeluaranService.instance.getAllPengeluaran();
      setState(() {
        pengeluaranList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

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
              lainnyaOnPressed: () =>
                  context.pushNamed('pengeluaran_daftar').then((_) {
                // Reload data setelah kembali
                _loadData();
              }),
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
    final topPengeluaran = pengeluaranList.take(limitItemShowed).toList();

    String _formatDate(DateTime date) {
      return DateFormat('EEEE, d MMM yyyy', 'id').format(date);
    }

    String _formatCurrency(int amount) {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    }

    Widget pengeluaranItem(Pengeluaran pengeluaran) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: topPengeluaran.length > 1 &&
                  topPengeluaran.length >= limitItemShowed
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
                          pengeluaran.kategori,
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
                              _formatCurrency(pengeluaran.nominal),
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              _formatDate(pengeluaran.tanggal),
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

    if (isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
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

    if (pengeluaranList.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: Text(
            'Belum ada data pengeluaran',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: List.generate(
            topPengeluaran.length,
            (index) {
              return pengeluaranItem(
                topPengeluaran[index],
              );
            },
          ),
        ),
        if (topPengeluaran.length > 1 &&
            topPengeluaran.length >= limitItemShowed)
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
        if (pengeluaranList.length > limitItemShowed)
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () => context.pushNamed('pengeluaran_daftar').then((_) {
                _loadData();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  "+${pengeluaranList.length - limitItemShowed} lainnya",
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
