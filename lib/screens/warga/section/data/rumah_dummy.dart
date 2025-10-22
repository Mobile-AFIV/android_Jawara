import 'package:flutter/material.dart';

class ResidentHistory {
  final String familyName;
  final String headOfFamily;
  final String moveInDate;
  final String? moveOutDate; // null means still living there

  ResidentHistory({
    required this.familyName,
    required this.headOfFamily,
    required this.moveInDate,
    this.moveOutDate,
  });
}

class RumahModel {
  final String address;
  final String status;
  final MaterialColor statusColor;
  final List<ResidentHistory> residentHistory;

  RumahModel({
    required this.address,
    required this.status,
    required this.statusColor,
    this.residentHistory = const [],
  });
}

class RumahDummy {
  // Status options
  static final List<String> statusOptions = [
    'Tersedia',
    'Ditempati'
  ];

  static List<RumahModel> dummyData = [
    RumahModel(
      address: 'Jl. Dahlia No. 15, RT 003/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Santoso',
          headOfFamily: 'Budi Santoso',
          moveInDate: '15 Januari 2023',
          moveOutDate: null,
        ),
        ResidentHistory(
          familyName: 'Keluarga Rahman',
          headOfFamily: 'Abdul Rahman',
          moveInDate: '5 Maret 2020',
          moveOutDate: '10 Januari 2023',
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Mawar No. 23, RT 005/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Rahmad',
          headOfFamily: 'Dewi Lestari',
          moveInDate: '20 Mei 2022',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Melati No. 8, RT 002/RW 003',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Wijaya',
          headOfFamily: 'Hendra Wijaya',
          moveInDate: '10 Februari 2021',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Anggrek No. 42, RT 004/RW 001',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Prasetyo',
          headOfFamily: 'Dimas Prasetyo',
          moveInDate: '3 Juli 2023',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Kenanga No. 12, RT 001/RW 004',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Kusuma',
          headOfFamily: 'Andi Kusuma',
          moveInDate: '18 Maret 2020',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Teratai No. 7, RT 006/RW 003',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Hartono',
          headOfFamily: 'Rudi Hartono',
          moveInDate: '25 September 2021',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Flamboyan No. 33, RT 002/RW 005',
      status: 'Tersedia',
      statusColor: Colors.green,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Susilo',
          headOfFamily: 'Joko Susilo',
          moveInDate: '22 Juni 2018',
          moveOutDate: '5 Agustus 2023',
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Cempaka No. 19, RT 007/RW 001',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Setiawan',
          headOfFamily: 'Bambang Setiawan',
          moveInDate: '12 November 2022',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Bougenville No. 28, RT 003/RW 004',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Salim',
          headOfFamily: 'Agus Salim',
          moveInDate: '7 April 2021',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Kamboja No. 5, RT 008/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Pranoto',
          headOfFamily: 'Yudi Pranoto',
          moveInDate: '22 Juni 2023',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Seruni No. 14, RT 001/RW 001',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Rahman',
          headOfFamily: 'Abdul Rahman',
          moveInDate: '14 Februari 2019',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Gardenia No. 21, RT 004/RW 003',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Hermawan',
          headOfFamily: 'Eko Hermawan',
          moveInDate: '30 Mei 2022',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Bakung No. 9, RT 005/RW 004',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Hakim',
          headOfFamily: 'Lukman Hakim',
          moveInDate: '8 Desember 2020',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Sakura No. 36, RT 006/RW 005',
      status: 'Tersedia',
      statusColor: Colors.green,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Nugroho',
          headOfFamily: 'Teguh Nugroho',
          moveInDate: '15 Maret 2019',
          moveOutDate: '19 Oktober 2024',
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Tulip No. 18, RT 007/RW 001',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Kurniawan',
          headOfFamily: 'Andi Kurniawan',
          moveInDate: '5 Maret 2023',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Lavender No. 25, RT 008/RW 003',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Wibowo',
          headOfFamily: 'Arif Wibowo',
          moveInDate: '11 Juli 2022',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Azalea No. 11, RT 001/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Hidayat',
          headOfFamily: 'Dedi Hidayat',
          moveInDate: '27 September 2021',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Lily No. 30, RT 002/RW 004',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Gunawan',
          headOfFamily: 'Irwan Gunawan',
          moveInDate: '16 Januari 2024',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Peony No. 17, RT 003/RW 005',
      status: 'Ditempati',
      statusColor: Colors.blue,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Saputra',
          headOfFamily: 'Rian Saputra',
          moveInDate: '4 November 2023',
          moveOutDate: null,
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Jasmine No. 44, RT 004/RW 001',
      status: 'Tersedia',
      statusColor: Colors.green,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Firmansyah',
          headOfFamily: 'Fikri Firmansyah',
          moveInDate: '10 Januari 2022',
          moveOutDate: '20 Agustus 2024',
        ),
      ],
    ),
  ];

  // Method to add new house data
  static void addRumah(RumahModel rumah) {
    dummyData.add(rumah);
  }
}