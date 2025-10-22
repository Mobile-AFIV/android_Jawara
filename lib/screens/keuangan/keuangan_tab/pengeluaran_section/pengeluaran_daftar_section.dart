import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pengeluaran_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/screens/keuangan/widget/modal_bottom_sheet.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PengeluaranDaftarSection extends StatefulWidget {
  PengeluaranDaftarSection({super.key});

  @override
  State<PengeluaranDaftarSection> createState() =>
      _PengeluaranDaftarSectionState();
}

class _PengeluaranDaftarSectionState extends State<PengeluaranDaftarSection> {
  String dateParse(String input, {String monthFormat = 'MMM'}) {
    final parser = DateFormat('d MMMM yyyy', 'id');
    final date = parser.parse(input);

    final String output =
        DateFormat('EEEE, d $monthFormat yyyy', 'id').format(date);

    return output;
  }

  final List<PengeluaranData> pengeluaran = List.generate(
    PengeluaranSectionData.pengeluaranData.length,
    (index) {
      return PengeluaranData.fromJson(
        PengeluaranSectionData.pengeluaranData[index],
      );
    },
  );

  Future<void> _showDetailPengeluaran(PengeluaranData data) async {
    ModalBottomSheet.showCustomModalBottomSheet(
      context: context,
      children: (_) => [
        const Text(
          "Detail Pengeluaran",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "Nama Pengeluaran",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.nama,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.jenisPengeluaran,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Tanggal Transaksi",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          dateParse(data.tanggal, monthFormat: "MMMM"),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Jumlah",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          "Rp${data.nominal},00",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          "Verfikator",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          data.verifikator,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget pengeluaranItemData(PengeluaranData itemData) {
    return InkWell(
      onTap: () => _showDetailPengeluaran(itemData),
      child: Container(
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
              itemData.jenisPengeluaran,
              style: const TextStyle(
                fontSize: 12,
                color: AppStyles.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              overflow: TextOverflow.ellipsis,
              itemData.nama,
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
                  "Rp${itemData.nominal},00",
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  dateParse(itemData.tanggal),
                  // itemData.tanggal,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Pengeluaran",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: () {}),
          const SizedBox(width: 8),
          AppBarActionButton.pdfDownload(onTap: () {}),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pengeluaran.length,
        itemBuilder: (context, index) {
          return pengeluaranItemData(pengeluaran[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey.shade300,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {
          // _showTambahPengeluaran();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PengeluaranData {
  final int no;
  final String nama;
  final String jenisPengeluaran;
  final String tanggal;
  final int nominal;
  final String verifikator;

  PengeluaranData({
    required this.no,
    required this.nama,
    required this.jenisPengeluaran,
    required this.tanggal,
    required this.nominal,
    required this.verifikator,
  });

  factory PengeluaranData.fromJson(Map<String, dynamic> json) {
    return PengeluaranData(
      no: json['no'],
      nama: json['nama'],
      jenisPengeluaran: json['jenisPengeluaran'],
      tanggal: json['tanggal'],
      nominal: json['nominal'],
      verifikator: json['verifikator'],
    );
  }
}
