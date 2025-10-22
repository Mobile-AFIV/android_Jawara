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
      nik: '3507012345678931',
      email: 'ahmad.setiawan@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Dewi Susanti',
      nik: '3507012345678932',
      email: 'dewi.susanti@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Rudi Hartono',
      nik: '3507012345678933',
      email: 'rudi.hartono@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Ditolak',
      statusColor: Colors.red,
      rejectionReason: 'Data tidak lengkap',
    ),
    PenerimaanWargaModel(
      name: 'Siti Nurhaliza',
      nik: '3507012345678934',
      email: 'siti.nurhaliza@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Bambang Pamungkas',
      nik: '3507012345678935',
      email: 'bambang.p@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Rina Melati',
      nik: '3507012345678936',
      email: 'rina.melati@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Fajar Nugraha',
      nik: '3507012345678937',
      email: 'fajar.nugraha@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Ditolak',
      statusColor: Colors.red,
      rejectionReason: 'NIK tidak valid',
    ),
    PenerimaanWargaModel(
      name: 'Maya Sari',
      nik: '3507012345678938',
      email: 'maya.sari@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Eko Prasetyo',
      nik: '3507012345678939',
      email: 'eko.prasetyo@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Indah Permata',
      nik: '3507012345678940',
      email: 'indah.permata@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Yoga Aditya',
      nik: '3507012345678941',
      email: 'yoga.aditya@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Lina Marlina',
      nik: '3507012345678942',
      email: 'lina.marlina@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Ditolak',
      statusColor: Colors.red,
      rejectionReason: 'Dokumen pendukung tidak lengkap',
    ),
    PenerimaanWargaModel(
      name: 'Doni Hermawan',
      nik: '3507012345678943',
      email: 'doni.hermawan@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Putri Ayu',
      nik: '3507012345678944',
      email: 'putri.ayu@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Hadi Wijaya',
      nik: '3507012345678945',
      email: 'hadi.wijaya@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Nisa Rahma',
      nik: '3507012345678946',
      email: 'nisa.rahma@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Rizky Fauzan',
      nik: '3507012345678947',
      email: 'rizky.fauzan@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Ditolak',
      statusColor: Colors.red,
      rejectionReason: 'Tidak memenuhi syarat domisili',
    ),
    PenerimaanWargaModel(
      name: 'Wulan Dari',
      nik: '3507012345678948',
      email: 'wulan.dari@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
    PenerimaanWargaModel(
      name: 'Arief Rahman',
      nik: '3507012345678949',
      email: 'arief.rahman@email.com',
      gender: 'Laki-laki',
      registrationStatus: 'Menunggu',
      statusColor: Colors.amber,
    ),
    PenerimaanWargaModel(
      name: 'Tari Lestari',
      nik: '3507012345678950',
      email: 'tari.lestari@email.com',
      gender: 'Perempuan',
      registrationStatus: 'Diterima',
      statusColor: Colors.green,
    ),
  ];
}