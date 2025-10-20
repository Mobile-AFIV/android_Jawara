import 'package:flutter/material.dart';

class PenerimaanWargaModel {
  final String name;
  final String nik;
  final String email;
  final String gender;
  String registrationStatus;
  MaterialColor statusColor;
  String? rejectionReason;

  PenerimaanWargaModel({
    required this.name,
    required this.nik,
    required this.email,
    required this.gender,
    required this.registrationStatus,
    required this.statusColor,
    this.rejectionReason,
  });
}

class PenerimaanWargaDummy {
  static List<PenerimaanWargaModel> dummyData = [
    PenerimaanWargaModel(
      name: 'Ahmad Setiawan',
      nik: '3507012345678901',
      email: 'ahmad.s@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Dewi Susanti',
      nik: '3507012345678902',
      email: 'dewi.s@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Rudi Hartono',
      nik: '3507012345678903',
      email: 'rudi.h@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Ditolak',
      statusColor: Colors.red,
      rejectionReason: 'Data tidak lengkap',
    ),
  ];
}