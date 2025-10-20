import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/data/pemasukan_section_data.dart';
import 'package:jawara_pintar/screens/keuangan/widget/appbar_action_button.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class PemasukanLainSection extends StatelessWidget {
  const PemasukanLainSection({super.key});

  String dateParse(String input) {
    final parser = DateFormat('d MMMM yyyy', 'id');
    final date = parser.parse(input);

    final String output = DateFormat('EEEE, d MMM yyyy', 'id').format(date);

    return output;
  }

  @override
  Widget build(BuildContext context) {
    final dataList = PemasukanSectionData.pemasukanLainData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Pemasukan Lain",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AppBarActionButton.filter(onTap: () {}),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return pemasukanLainItem(
            PemasukanLainData.fromJson(dataList[index]),
          );
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
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppStyles.primaryColor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget pemasukanLainItem(PemasukanLainData itemData) {
    return Container(
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
            itemData.jenisPemasukan,
            style: const TextStyle(
              fontSize: 12,
              color: AppStyles.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            overflow: TextOverflow.ellipsis,
            itemData.nama,
            style: TextStyle(
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PemasukanLainData {
  final int no;
  final String nama;
  final String jenisPemasukan;
  final String tanggal;
  final int nominal;

  PemasukanLainData({
    required this.no,
    required this.nama,
    required this.jenisPemasukan,
    required this.tanggal,
    required this.nominal,
  });

  factory PemasukanLainData.fromJson(Map<String, dynamic> json) {
    return PemasukanLainData(
      no: json['no'],
      nama: json['nama'],
      jenisPemasukan: json['jenisPemasukan'],
      tanggal: json['tanggal'],
      nominal: json['nominal'],
    );
  }
}
