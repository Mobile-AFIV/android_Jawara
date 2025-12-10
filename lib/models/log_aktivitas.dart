import 'package:cloud_firestore/cloud_firestore.dart';

class LogAktivitas {
  final String id;
  final String deskripsi;
  final String aktor;
  final DateTime waktu;

  LogAktivitas({
    required this.id,
    required this.deskripsi,
    required this.aktor,
    required this.waktu,
});

  factory LogAktivitas.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LogAktivitas(
      id: doc.id,
      deskripsi: data['deskripsi'],
      aktor: data['aktor'],
      waktu: (data['waktu'] as Timestamp).toDate(),
    );
  }
}


