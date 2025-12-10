import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String namaLengkap;
  final String jenisKelamin;
  final String nik;
  final String noTelepon;
  final String role;
  // final String email;
  // final String password;
  final DocumentReference rumah;

  UserProfile({
    required this.uid,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.nik,
    required this.noTelepon,
    required this.rumah,
    required this.role,
    // required this.password,
    // required this.email,  
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      uid: data['uid'],
      namaLengkap: data['namaLengkap'],
      jenisKelamin: data['jenisKelamin'],
      // email: data['email'],
      // password: data['password'],
      nik: data['nik'],
      noTelepon: data['noTelepon'],
      rumah: data['rumah'],
      role: data['role'],
    );
  }
}
