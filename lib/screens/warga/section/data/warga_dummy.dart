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
  // Dropdown options
  static final List<String> genderOptions = [
    'Laki-laki',
    'Perempuan'
  ];

  static final List<String> religionOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
    'Lainnya'
  ];

  static final List<String> bloodTypeOptions = [
    'A',
    'B',
    'AB',
    'O',
    'Tidak tahu'
  ];

  static final List<String> educationOptions = [
    'Tidak sekolah',
    'SD/MI',
    'SMP/MTs',
    'SMA/SMK/MA',
    'Sarjana/Diploma',
    'Magister',
    'Doktor'
  ];

  static final List<String> jobOptions = [
    'Pelajar/Mahasiswa',
    'Pegawai Negeri',
    'Pegawai Swasta',
    'Wiraswasta',
    'Guru/Dosen',
    'TNI/Polri',
    'Pensiunan',
    'Tidak Bekerja',
    'Lainnya'
  ];

  static final List<String> familyRoleOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Orang Tua',
    'Saudara',
    'Lainnya'
  ];

  static final List<String> statusOptions = [
    'Aktif',
    'Nonaktif'
  ];

  static final List<String> lifeStatusOptions = [
    'Hidup',
    'Wafat'
  ];

  // Common cities in Indonesia for birthplace suggestions
  static final List<String> cityOptions = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Yogyakarta',
    'Denpasar',
    'Padang',
    'Malang',
    'Balikpapan',
    'Manado',
    'Samarinda',
    'Pekanbaru',
    'Djawa'
  ];

  // Existing dummy data
  static List<WargaModel> dummyData = [
    WargaModel(
      name: "Budi Santoso",
      nik: "3507012345678901",
      family: "Keluarga Santoso",
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
      family: "Keluarga Santoso",
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
      family: "Keluarga Santoso",
      gender: "Laki-laki",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Bandung",
      birthDate: "10 Juni 2000",
      phoneNumber: "08345678901",
      religion: "Islam",
      bloodType: "O",
      education: "SMA/Sederajat",
      job: "Pelajar/Mahasiswa",
      familyRole: "Anak",
    ),
    WargaModel(
      name: "Muhammad Sumbul",
      nik: "3507012345678904",
      family: "Keluarga Tes",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Djawa",
      birthDate: "31 Januari 2025",
      phoneNumber: "0823456789",
      religion: "Islam",
      bloodType: "O",
      education: "Sarjana/Diploma",
      job: "Pegawai",
      familyRole: "Anak",
    ),
  ];

  // Method to add new warga data
  static void addWarga(WargaModel warga) {
    dummyData.add(warga);
  }
}