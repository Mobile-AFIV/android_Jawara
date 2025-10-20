import 'package:flutter/material.dart';

class RumahModel {
  final String address;
  final String status;
  final MaterialColor statusColor;

  RumahModel({
    required this.address,
    required this.status,
    required this.statusColor,
  });
}

class RumahDummy {
  static List<RumahModel> dummyData = [
    RumahModel(
      address: 'Jl. Dahlia No. 15, RT 003/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
    ),
    RumahModel(
      address: 'Jl. Mawar No. 23, RT 005/RW 002',
      status: 'Ditempati',
      statusColor: Colors.blue,
    ),
    RumahModel(
      address: 'Jl. Melati No. 8, RT 002/RW 003',
      status: 'Tersedia',
      statusColor: Colors.green,
    ),
    RumahModel(
      address: 'Jl. Anggrek No. 42, RT 004/RW 001',
      status: 'Tersedia',
      statusColor: Colors.green,
    ),
  ];
}