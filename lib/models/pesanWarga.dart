import 'package:cloud_firestore/cloud_firestore.dart';

class PesanWargaModel {
  final String id;
  final String namaWarga;
  final String isiPesan;

  PesanWargaModel({
    required this.id,
    required this.namaWarga,
    required this.isiPesan,
  });

  factory PesanWargaModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PesanWargaModel(
      id: doc.id,
      namaWarga: data['namaWarga'],
      isiPesan: data['isi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "namaWarga": namaWarga,
      "isi": isiPesan,
    };
  }
}
