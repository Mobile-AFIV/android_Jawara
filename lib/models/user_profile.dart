import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String namaLengkap;
  final String jenisKelamin;
  final String nik;
  final String noTelepon;
  final DocumentReference rumah;

  UserProfile({
    required this.uid,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.nik,
    required this.noTelepon,
    required this.rumah,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      uid: data['uid'],
      namaLengkap: data['namaLengkap'],
      jenisKelamin: data['jenisKelamin'],
      nik: data['nik'],
      noTelepon: data['noTelepon'],
      rumah: data['rumah'],
    );
  }
}
