import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastModel {
  final String id;
  final String nama;
  final String isi;
  final String tanggal;
  final String dibuatOleh;


  BroadcastModel({
    this.id = "",
    required this.nama,
    required this.isi,
    required this.tanggal,
    required this.dibuatOleh,

  });

  factory BroadcastModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BroadcastModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      isi: data['isi'] ?? '',
      tanggal: data['tanggal'] ?? '',
      dibuatOleh: data['dibuatOleh'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "isi": isi,
      "tanggal": tanggal,
      "dibuatOleh": dibuatOleh,

    };
  }
}
