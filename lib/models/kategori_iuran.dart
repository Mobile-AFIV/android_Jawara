import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriIuran {
  final String id;
  final String nama;
  final String jenis;
  final double nominal;

  KategoriIuran({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.nominal,
  });

  factory KategoriIuran.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return KategoriIuran(
      id: doc.id,
      nama: data['nama'],
      jenis: data['jenis_iuran'],
      nominal: data['nominal'],
    );
  }
}
