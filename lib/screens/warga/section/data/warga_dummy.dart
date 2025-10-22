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
      lifeStatus: "Hidup",
      birthPlace: "Surabaya",
      birthDate: "22 April 1985",
      phoneNumber: "08234567890",
      religion: "Islam",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Guru/Dosen",
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
      birthDate: "10 Juni 2005",
      phoneNumber: "08345678901",
      religion: "Islam",
      bloodType: "O",
      education: "SMA/SMK/MA",
      job: "Pelajar/Mahasiswa",
      familyRole: "Anak",
    ),
    WargaModel(
      name: "Dewi Lestari",
      nik: "3507012345678904",
      family: "Keluarga Rahmad",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Medan",
      birthDate: "8 Februari 1990",
      phoneNumber: "08123456780",
      religion: "Kristen",
      bloodType: "A",
      education: "Sarjana/Diploma",
      job: "Pegawai Swasta",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Hendra Wijaya",
      nik: "3507012345678905",
      family: "Keluarga Wijaya",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Semarang",
      birthDate: "20 Mei 1978",
      phoneNumber: "08234567891",
      religion: "Buddha",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Wiraswasta",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Rina Wijaya",
      nik: "3507012345678906",
      family: "Keluarga Wijaya",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Yogyakarta",
      birthDate: "12 Juli 1982",
      phoneNumber: "08345678902",
      religion: "Buddha",
      bloodType: "O",
      education: "SMA/SMK/MA",
      job: "Tidak Bekerja",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Dimas Prasetyo",
      nik: "3507012345678907",
      family: "Keluarga Prasetyo",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Makassar",
      birthDate: "5 September 1988",
      phoneNumber: "08456789012",
      religion: "Islam",
      bloodType: "AB",
      education: "Sarjana/Diploma",
      job: "Pegawai Negeri",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Fatimah Zahra",
      nik: "3507012345678908",
      family: "Keluarga Prasetyo",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Palembang",
      birthDate: "18 November 1992",
      phoneNumber: "08567890123",
      religion: "Islam",
      bloodType: "A",
      education: "Sarjana/Diploma",
      job: "Guru/Dosen",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Andi Kusuma",
      nik: "3507012345678909",
      family: "Keluarga Kusuma",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Denpasar",
      birthDate: "3 Januari 1975",
      phoneNumber: "08678901234",
      religion: "Hindu",
      bloodType: "B",
      education: "Magister",
      job: "Guru/Dosen",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Wayan Sari",
      nik: "3507012345678910",
      family: "Keluarga Kusuma",
      gender: "Perempuan",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Denpasar",
      birthDate: "25 Maret 1977",
      phoneNumber: "08789012345",
      religion: "Hindu",
      bloodType: "O",
      education: "Sarjana/Diploma",
      job: "Wiraswasta",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Rudi Hartono",
      nik: "3507012345678911",
      family: "Keluarga Hartono",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Padang",
      birthDate: "14 Agustus 1983",
      phoneNumber: "08890123456",
      religion: "Islam",
      bloodType: "A",
      education: "SMA/SMK/MA",
      job: "TNI/Polri",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Sri Wahyuni",
      nik: "3507012345678912",
      family: "Keluarga Hartono",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Malang",
      birthDate: "7 Desember 1986",
      phoneNumber: "08901234567",
      religion: "Islam",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Pegawai Swasta",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Joko Susilo",
      nik: "3507012345678913",
      family: "Keluarga Susilo",
      gender: "Laki-laki",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Balikpapan",
      birthDate: "22 Juni 1970",
      phoneNumber: "08012345678",
      religion: "Katolik",
      bloodType: "AB",
      education: "Sarjana/Diploma",
      job: "Pensiunan",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Maria Susilo",
      nik: "3507012345678914",
      family: "Keluarga Susilo",
      gender: "Perempuan",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Manado",
      birthDate: "30 April 1972",
      phoneNumber: "08112345678",
      religion: "Katolik",
      bloodType: "O",
      education: "SMA/SMK/MA",
      job: "Tidak Bekerja",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Bambang Setiawan",
      nik: "3507012345678915",
      family: "Keluarga Setiawan",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Samarinda",
      birthDate: "16 Oktober 1995",
      phoneNumber: "08212345678",
      religion: "Islam",
      bloodType: "A",
      education: "Sarjana/Diploma",
      job: "Pegawai Swasta",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Linda Setiawan",
      nik: "3507012345678916",
      family: "Keluarga Setiawan",
      gender: "Perempuan",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Pekanbaru",
      birthDate: "9 Mei 1997",
      phoneNumber: "08312345678",
      religion: "Islam",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Guru/Dosen",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Agus Salim",
      nik: "3507012345678917",
      family: "Keluarga Salim",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Jakarta",
      birthDate: "28 Februari 1985",
      phoneNumber: "08412345678",
      religion: "Islam",
      bloodType: "O",
      education: "Magister",
      job: "Pegawai Negeri",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Nurul Salim",
      nik: "3507012345678918",
      family: "Keluarga Salim",
      gender: "Perempuan",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Bandung",
      birthDate: "11 Juli 1987",
      phoneNumber: "08512345678",
      religion: "Islam",
      bloodType: "A",
      education: "Sarjana/Diploma",
      job: "Wiraswasta",
      familyRole: "Istri",
    ),
    WargaModel(
      name: "Yudi Pranoto",
      nik: "3507012345678919",
      family: "Keluarga Pranoto",
      gender: "Laki-laki",
      domicileStatus: "Aktif",
      lifeStatus: "Hidup",
      birthPlace: "Surabaya",
      birthDate: "4 Maret 1991",
      phoneNumber: "08612345678",
      religion: "Kristen",
      bloodType: "B",
      education: "Sarjana/Diploma",
      job: "Pegawai Swasta",
      familyRole: "Kepala Keluarga",
    ),
    WargaModel(
      name: "Sari Pranoto",
      nik: "3507012345678920",
      family: "Keluarga Pranoto",
      gender: "Perempuan",
      domicileStatus: "Nonaktif",
      lifeStatus: "Hidup",
      birthPlace: "Medan",
      birthDate: "19 September 1993",
      phoneNumber: "08712345678",
      religion: "Kristen",
      bloodType: "AB",
      education: "Sarjana/Diploma",
      job: "Guru/Dosen",
      familyRole: "Istri",
    ),
  ];

  // Method to add new warga data
  static void addWarga(WargaModel warga) {
    dummyData.add(warga);
  }
}