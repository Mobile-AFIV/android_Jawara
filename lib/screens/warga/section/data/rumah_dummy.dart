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
          moveOutDate: null, // still living there
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
          headOfFamily: 'Ahmad Rahmad',
          moveInDate: '20 Mei 2022',
          moveOutDate: null, // still living there
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Melati No. 8, RT 002/RW 003',
      status: 'Tersedia',
      statusColor: Colors.green,
      residentHistory: [
        ResidentHistory(
          familyName: 'Keluarga Wijaya',
          headOfFamily: 'Hendra Wijaya',
          moveInDate: '10 Februari 2021',
          moveOutDate: '5 Agustus 2023',
        ),
      ],
    ),
    RumahModel(
      address: 'Jl. Anggrek No. 42, RT 004/RW 001',
      status: 'Tersedia',
      statusColor: Colors.green,
      residentHistory: [],
    ),
  ];

  // Method to add new house data
  static void addRumah(RumahModel rumah) {
    dummyData.add(rumah);
  }
}