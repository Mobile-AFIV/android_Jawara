import 'package:flutter/material.dart';

class WargaModel {
  final String name;
  final String nik;
  final String family;
  final String gender;
  final String domicileStatus;
  final String lifeStatus;

  // Additional fields for detail
  final String birthPlace;
  final String birthDate;
  final String phoneNumber;
  final String religion;
  final String bloodType;
  final String education;
  final String job;
  final String familyRole;

  WargaModel({
    required this.name,
    required this.nik,
    required this.family,
    required this.gender,
    required this.domicileStatus,
    required this.lifeStatus,
    this.birthPlace = '',
    this.birthDate = '',
    this.phoneNumber = '',
    this.religion = '',
    this.bloodType = '',
    this.education = '',
    this.job = '',
    this.familyRole = '',
  });
}

class WargaDummy {
  static List<WargaModel> dummyData = [
    WargaModel(
      name: "Budi Santoso",
      nik: "3507012345678901",
      family: "Kepala Keluarga",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Jakarta",
      birthDate: "15 Maret 1980",
      phoneNumber: "08123456789",
      religion: "Islam",
      bloodType: "A",
      education: "Sarjana/Diploma",
      job: "Wiraswasta",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Siti Rahayu",
      nik: "3507012345678902",
      family: "Istri",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Wafat",
      birthPlace: "Surabaya",
      birthDate: "22 April 1985",
      phoneNumber: "08234567890",
      religion: "Islam",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Guru",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Ahmad Fauzi",
      nik: "3507012345678903",
      family: "Anak",
      gender: "Laki-laki",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Bandung",
      birthDate: "10 Juni 2000",
      phoneNumber: "08345678901",
      religion: "Islam",
      bloodType: "O",
      education: "SMA/Sederajat",
      job: "Mahasiswa",
      familyRole: "Anak",
    ),
  ];
}