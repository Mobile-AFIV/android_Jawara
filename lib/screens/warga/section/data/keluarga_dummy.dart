import 'package:flutter/material.dart';

class KeluargaModel {
  final String familyName;
  final String headOfFamily;
  final String address;
  final String ownershipStatus;
  final String status;
  final MaterialColor statusColor;

  KeluargaModel({
    required this.familyName,
    required this.headOfFamily,
    required this.address,
    required this.ownershipStatus,
    required this.status,
    required this.statusColor,
  });
}

class KeluargaDummy {
  static List<KeluargaModel> dummyData = [
    KeluargaModel(
      familyName: 'Keluarga Santoso',
      headOfFamily: 'Budi Santoso',
      address: 'Jl. Dahlia No. 15, RT 003/RW 002',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
    ),
    KeluargaModel(
      familyName: 'Keluarga Rahmad',
      headOfFamily: 'Ahmad Rahmad',
      address: 'Jl. Mawar No. 23, RT 005/RW 002',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
    ),
    KeluargaModel(
      familyName: 'Keluarga Wijaya',
      headOfFamily: 'Hendra Wijaya',
      address: 'Jl. Melati No. 8, RT 002/RW 003',
      ownershipStatus: 'Pemilik',
      status: 'Nonaktif',
      statusColor: Colors.red,
    ),
    KeluargaModel(
      familyName: 'Keluarga Prasetyo',
      headOfFamily: 'Dimas Prasetyo',
      address: 'Jl. Anggrek No. 42, RT 004/RW 001',
      ownershipStatus: 'Penyewa',
      status: 'Nonaktif',
      statusColor: Colors.red,
    ),
  ];
}