import 'package:flutter/material.dart';

class MutasiKeluargaModel {
  final String familyName;
  final String date;
  final String mutationType;
  final MaterialColor statusColor;

  MutasiKeluargaModel({
    required this.familyName,
    required this.date,
    required this.mutationType,
    required this.statusColor,
  });
}

class MutasiKeluargaDummy {
  static List<MutasiKeluargaModel> dummyData = [
    MutasiKeluargaModel(
      familyName: 'Keluarga Jeha',
      date: '25 Oktober 2023',
      mutationType: 'Pindah Rumah',
      statusColor: Colors.green,
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Fikri',
      date: '30 November 2023',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Ahmad',
      date: '15 Januari 2024',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Santoso',
      date: '7 Maret 2024',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
    ),
  ];
}