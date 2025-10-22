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
      familyName: 'Keluarga Santoso',
      date: '15 Januari 2023',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Raya Bekasi No. 45, Jakarta',
      newAddress: 'Jl. Dahlia No. 15, RT 003/RW 002',
      reason: 'Ingin dekat dengan keluarga',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Rahmad',
      date: '20 Mei 2022',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Sudirman No. 12, Medan',
      newAddress: 'Jl. Mawar No. 23, RT 005/RW 002',
      reason: 'Pindah tugas kerja',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Wijaya',
      date: '10 Februari 2021',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Ahmad Yani No. 78, Semarang',
      newAddress: 'Jl. Melati No. 8, RT 002/RW 003',
      reason: 'Mencari lingkungan yang lebih baik',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Prasetyo',
      date: '3 Juli 2023',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Diponegoro No. 90, Bandung',
      newAddress: 'Jl. Anggrek No. 42, RT 004/RW 001',
      reason: 'Ingin dekat sekolah anak',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Kusuma',
      date: '18 Maret 2020',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Veteran No. 23, Denpasar',
      newAddress: 'Jl. Kenanga No. 12, RT 001/RW 004',
      reason: 'Mengikuti suami yang pindah kerja',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Hartono',
      date: '25 September 2021',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Gajah Mada No. 56, Padang',
      newAddress: 'Jl. Teratai No. 7, RT 006/RW 003',
      reason: 'Penugasan TNI',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Susilo',
      date: '5 Agustus 2023',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
      oldAddress: 'Jl. Flamboyan No. 33, RT 002/RW 005',
      newAddress: 'Jl. Raya Bogor No. 88, Jakarta',
      reason: 'Pensiun dan ingin tinggal dekat anak',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Setiawan',
      date: '12 November 2022',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Pahlawan No. 34, Samarinda',
      newAddress: 'Jl. Cempaka No. 19, RT 007/RW 001',
      reason: 'Pekerjaan baru di kota ini',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Salim',
      date: '7 April 2021',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Pemuda No. 67, Surabaya',
      newAddress: 'Jl. Bougenville No. 28, RT 003/RW 004',
      reason: 'Promosi jabatan',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Pranoto',
      date: '22 Juni 2023',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Merdeka No. 45, Malang',
      newAddress: 'Jl. Kamboja No. 5, RT 008/RW 002',
      reason: 'Ingin rumah yang lebih besar',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Rahman',
      date: '14 Februari 2019',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Gatot Subroto No. 12, Makassar',
      newAddress: 'Jl. Seruni No. 14, RT 001/RW 001',
      reason: 'Membuka usaha baru',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Hermawan',
      date: '30 Mei 2022',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Hayam Wuruk No. 89, Yogyakarta',
      newAddress: 'Jl. Gardenia No. 21, RT 004/RW 003',
      reason: 'Mencari suasana baru',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Hakim',
      date: '8 Desember 2020',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Thamrin No. 56, Palembang',
      newAddress: 'Jl. Bakung No. 9, RT 005/RW 004',
      reason: 'Rotasi pegawai negeri',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Nugroho',
      date: '19 Oktober 2024',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
      oldAddress: 'Jl. Sakura No. 36, RT 006/RW 005',
      newAddress: 'Jl. Raya Cikarang No. 23, Bekasi',
      reason: 'Pindah kerja ke luar kota',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Kurniawan',
      date: '5 Maret 2023',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Imam Bonjol No. 34, Balikpapan',
      newAddress: 'Jl. Tulip No. 18, RT 007/RW 001',
      reason: 'Dekat dengan kampus',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Wibowo',
      date: '11 Juli 2022',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Juanda No. 67, Manado',
      newAddress: 'Jl. Lavender No. 25, RT 008/RW 003',
      reason: 'Ikut orang tua',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Hidayat',
      date: '27 September 2021',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Sisingamangaraja No. 45, Pekanbaru',
      newAddress: 'Jl. Azalea No. 11, RT 001/RW 002',
      reason: 'Warisan rumah keluarga',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Gunawan',
      date: '16 Januari 2024',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Ahmad Dahlan No. 89, Tangerang',
      newAddress: 'Jl. Lily No. 30, RT 002/RW 004',
      reason: 'Kontrak habis, cari rumah baru',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Saputra',
      date: '4 November 2023',
      mutationType: 'Pindah Masuk',
      statusColor: Colors.green,
      oldAddress: 'Jl. Panglima Sudirman No. 12, Pontianak',
      newAddress: 'Jl. Peony No. 17, RT 003/RW 005',
      reason: 'Menikah dan mandiri',
    ),
    MutasiKeluargaModel(
      familyName: 'Keluarga Firmansyah',
      date: '20 Agustus 2024',
      mutationType: 'Keluar Wilayah',
      statusColor: Colors.red,
      oldAddress: 'Jl. Jasmine No. 44, RT 004/RW 001',
      newAddress: 'Jl. Raya Solo No. 67, Surakarta',
      reason: 'Ikut program pemerintah',
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