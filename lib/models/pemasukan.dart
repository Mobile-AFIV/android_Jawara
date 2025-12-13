import 'package:cloud_firestore/cloud_firestore.dart';

class Pemasukan {
  final String id;
  final String nama;
  final String kategori;
  final DateTime tanggal;
  final int nominal;
  final String verifikator;
  final String? buktiUrl; // optional untuk URL bukti pemasukan

  Pemasukan({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.tanggal,
    required this.nominal,
    required this.verifikator,
    this.buktiUrl,
  });

  factory Pemasukan.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Pemasukan(
      id: doc.id,
      nama: data['nama'] ?? '',
      kategori: data['kategori'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      nominal: data['nominal'] ?? 0,
      verifikator: data['verifikator'] ?? '',
      buktiUrl: data['bukti_url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nama': nama,
      'kategori': kategori,
      'tanggal': Timestamp.fromDate(tanggal),
      'nominal': nominal,
      'verifikator': verifikator,
      'bukti_url': buktiUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
