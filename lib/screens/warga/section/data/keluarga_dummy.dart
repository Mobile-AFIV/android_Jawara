import 'package:flutter/material.dart';

class FamilyMember {
  final String name;
  final String nik;
  final String role;
  final String gender;
  final String birthDate;
  final String status;

  FamilyMember({
    required this.name,
    required this.nik,
    required this.role,
    required this.gender,
    required this.birthDate,
    required this.status,
  });
}

class KeluargaModel {
  final String familyName;
  final String headOfFamily;
  final String address;
  final String ownershipStatus;
  final String status;
  final MaterialColor statusColor;
  final List<FamilyMember> members;

  KeluargaModel({
    required this.familyName,
    required this.headOfFamily,
    required this.address,
    required this.ownershipStatus,
    required this.status,
    required this.statusColor,
    required this.members,
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
      members: [
        FamilyMember(
          name: 'Budi Santoso',
          nik: '3507012345678901',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '15 Maret 1980',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Siti Rahayu',
          nik: '3507012345678902',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '22 April 1985',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Ahmad Fauzi',
          nik: '3507012345678903',
          role: 'Anak',
          gender: 'Laki-laki',
          birthDate: '10 Juni 2005',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Rahmad',
      headOfFamily: 'Dewi Lestari',
      address: 'Jl. Mawar No. 23, RT 005/RW 002',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Dewi Lestari',
          nik: '3507012345678904',
          role: 'Kepala Keluarga',
          gender: 'Perempuan',
          birthDate: '8 Februari 1990',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Wijaya',
      headOfFamily: 'Hendra Wijaya',
      address: 'Jl. Melati No. 8, RT 002/RW 003',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Hendra Wijaya',
          nik: '3507012345678905',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '20 Mei 1978',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Rina Wijaya',
          nik: '3507012345678906',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '12 Juli 1982',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Prasetyo',
      headOfFamily: 'Dimas Prasetyo',
      address: 'Jl. Anggrek No. 42, RT 004/RW 001',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Dimas Prasetyo',
          nik: '3507012345678907',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '5 September 1988',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Fatimah Zahra',
          nik: '3507012345678908',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '18 November 1992',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Kusuma',
      headOfFamily: 'Andi Kusuma',
      address: 'Jl. Kenanga No. 12, RT 001/RW 004',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Andi Kusuma',
          nik: '3507012345678909',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '3 Januari 1975',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Wayan Sari',
          nik: '3507012345678910',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '25 Maret 1977',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Hartono',
      headOfFamily: 'Rudi Hartono',
      address: 'Jl. Teratai No. 7, RT 006/RW 003',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Rudi Hartono',
          nik: '3507012345678911',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '14 Agustus 1983',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Sri Wahyuni',
          nik: '3507012345678912',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '7 Desember 1986',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Susilo',
      headOfFamily: 'Joko Susilo',
      address: 'Jl. Flamboyan No. 33, RT 002/RW 005',
      ownershipStatus: 'Pemilik',
      status: 'Nonaktif',
      statusColor: Colors.red,
      members: [
        FamilyMember(
          name: 'Joko Susilo',
          nik: '3507012345678913',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '22 Juni 1970',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Maria Susilo',
          nik: '3507012345678914',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '30 April 1972',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Setiawan',
      headOfFamily: 'Bambang Setiawan',
      address: 'Jl. Cempaka No. 19, RT 007/RW 001',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Bambang Setiawan',
          nik: '3507012345678915',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '16 Oktober 1995',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Linda Setiawan',
          nik: '3507012345678916',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '9 Mei 1997',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Salim',
      headOfFamily: 'Agus Salim',
      address: 'Jl. Bougenville No. 28, RT 003/RW 004',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Agus Salim',
          nik: '3507012345678917',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '28 Februari 1985',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Nurul Salim',
          nik: '3507012345678918',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '11 Juli 1987',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Pranoto',
      headOfFamily: 'Yudi Pranoto',
      address: 'Jl. Kamboja No. 5, RT 008/RW 002',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Yudi Pranoto',
          nik: '3507012345678919',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '4 Maret 1991',
          status: 'Hidup',
        ),
        FamilyMember(
          name: 'Sari Pranoto',
          nik: '3507012345678920',
          role: 'Istri',
          gender: 'Perempuan',
          birthDate: '19 September 1993',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Rahman',
      headOfFamily: 'Abdul Rahman',
      address: 'Jl. Seruni No. 14, RT 001/RW 001',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Abdul Rahman',
          nik: '3507012345678921',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '6 Juni 1976',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Hermawan',
      headOfFamily: 'Eko Hermawan',
      address: 'Jl. Gardenia No. 21, RT 004/RW 003',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Eko Hermawan',
          nik: '3507012345678922',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '12 Desember 1989',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Hakim',
      headOfFamily: 'Lukman Hakim',
      address: 'Jl. Bakung No. 9, RT 005/RW 004',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Lukman Hakim',
          nik: '3507012345678923',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '27 Juli 1981',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Nugroho',
      headOfFamily: 'Teguh Nugroho',
      address: 'Jl. Sakura No. 36, RT 006/RW 005',
      ownershipStatus: 'Penyewa',
      status: 'Nonaktif',
      statusColor: Colors.red,
      members: [
        FamilyMember(
          name: 'Teguh Nugroho',
          nik: '3507012345678924',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '3 Oktober 1984',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Kurniawan',
      headOfFamily: 'Andi Kurniawan',
      address: 'Jl. Tulip No. 18, RT 007/RW 001',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Andi Kurniawan',
          nik: '3507012345678925',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '15 Mei 1993',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Wibowo',
      headOfFamily: 'Arif Wibowo',
      address: 'Jl. Lavender No. 25, RT 008/RW 003',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Arif Wibowo',
          nik: '3507012345678926',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '20 Januari 1987',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Hidayat',
      headOfFamily: 'Dedi Hidayat',
      address: 'Jl. Azalea No. 11, RT 001/RW 002',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Dedi Hidayat',
          nik: '3507012345678927',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '8 November 1979',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Gunawan',
      headOfFamily: 'Irwan Gunawan',
      address: 'Jl. Lily No. 30, RT 002/RW 004',
      ownershipStatus: 'Penyewa',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Irwan Gunawan',
          nik: '3507012345678928',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '22 Agustus 1996',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Saputra',
      headOfFamily: 'Rian Saputra',
      address: 'Jl. Peony No. 17, RT 003/RW 005',
      ownershipStatus: 'Pemilik',
      status: 'Aktif',
      statusColor: Colors.green,
      members: [
        FamilyMember(
          name: 'Rian Saputra',
          nik: '3507012345678929',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '13 April 1992',
          status: 'Hidup',
        ),
      ],
    ),
    KeluargaModel(
      familyName: 'Keluarga Firmansyah',
      headOfFamily: 'Fikri Firmansyah',
      address: 'Jl. Jasmine No. 44, RT 004/RW 001',
      ownershipStatus: 'Penyewa',
      status: 'Nonaktif',
      statusColor: Colors.red,
      members: [
        FamilyMember(
          name: 'Fikri Firmansyah',
          nik: '3507012345678930',
          role: 'Kepala Keluarga',
          gender: 'Laki-laki',
          birthDate: '29 September 1990',
          status: 'Hidup',
        ),
      ],
    ),
  ];
}