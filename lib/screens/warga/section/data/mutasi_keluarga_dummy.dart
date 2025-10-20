import 'package:flutter/material.dart';

class MutasiKeluargaModel {
  final String familyName;
  final String date;
  final String mutationType;
  final MaterialColor statusColor;
  // Additional fields for detail
  final String oldAddress;
  final String newAddress;
  final String reason;

  MutasiKeluargaModel({
    required this.familyName,
    required this.date,
    required this.mutationType,
    required this.statusColor,
    this.oldAddress = '',
    this.newAddress = '',
    this.reason = '',
  });
}

class MutasiKeluargaDummy {
  // Mutation type options
  static final List<String> mutationTypeOptions = [
    'Pindah Masuk',
    'Keluar Wilayah',
  ];

  // Family options (for dropdown)
  static final List<String> familyOptions = [
    'Keluarga Santoso',
    'Keluarga Rahmad',
    'Keluarga Wijaya',
    'Keluarga Prasetyo',
    'Keluarga Tes',
    'Keluarga Ijat'
  ];

  static List<MutasiKeluargaModel> dummyData = [
    MutasiKeluargaModel(
      familyName: 'Keluarga Jeha',
      date: '25 Oktober 2023',
      mutationType: 'Pindah Rumah',
      statusColor: Colors.green,
      oldAddress: 'Jl. Dahlia No. 15, RT 003/RW 002',
      newAddress: 'Jl. Mawar No. 23, RT 005/RW 002',
      reason: 'Ingin rumah yang lebih besar',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Fikri',
      date: '30 November 2023',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
      oldAddress: 'Jl. Mawar No. 23, RT 005/RW 002',
      newAddress: '',
      reason: 'Pindah kota karena pekerjaan',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Ahmad',
      date: '15 Januari 2024',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: '',
      newAddress: 'Jl. Melati No. 8, RT 002/RW 003',
      reason: 'Baru pindah ke wilayah ini',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Santoso',
      date: '7 Maret 2024',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: '',
      newAddress: 'Jl. Anggrek No. 42, RT 004/RW 001',
      reason: 'Ingin dekat dengan keluarga',
    ),
    // Example data from previous image
    MutasiKeluargaModel(
      familyName: 'Keluarga Ijat',
      date: '15 Oktober 2025',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
      oldAddress: 'i',
      newAddress: '',
      reason: 'Karena mau keluar',
    ),
  ];

  // Get status color based on mutation type
  static MaterialColor getStatusColor(String mutationType) {
    switch (mutationType) {
      case 'Pindah Masuk':
        return Colors.green;
      case 'Keluar Wilayah':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Method to add new mutation data
  static void addMutasi(MutasiKeluargaModel mutasi) {
    dummyData.add(mutasi);
  }
}