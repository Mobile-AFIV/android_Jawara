import 'package:cloud_firestore/cloud_firestore.dart';

class ManajemenPengguna {
  final String id;
  final String namaLengkap;
  final String jenisKelamin;
  final String nik;
  final String email;
  final String role;
  final String noTelepon;
  final bool isActive;

  ManajemenPengguna({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.jenisKelamin,
    required this.nik,
    required this.noTelepon,
    required this.role,
    required this.isActive,
  });

  factory ManajemenPengguna.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ManajemenPengguna(
      id: doc.id,
      namaLengkap: data['namaLengkap'],
      email: data['email'],
      role: data['role'],
      isActive: data['isActive'],
      jenisKelamin: data['jenisKelamin'],
      nik: data['nik'],
      noTelepon: data['noTelepon'],
    );
  }
}