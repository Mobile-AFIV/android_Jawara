import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastModel {
  final String id;
  final String nama;
  final String isi;
  final String tanggal;
  final String dibuatOleh;
  final List<String> lampiranGambar;
  final List<String> lampiranPdf;

  BroadcastModel({
    this.id = "",
    required this.nama,
    required this.isi,
    required this.tanggal,
    required this.dibuatOleh,
    this.lampiranGambar = const [],
    this.lampiranPdf = const [],
  });

  factory BroadcastModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BroadcastModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      isi: data['isi'] ?? '',
      tanggal: data['tanggal'] ?? '',
      dibuatOleh: data['dibuatOleh'] ?? '',
      lampiranGambar: List<String>.from(data['lampiranGambar'] ?? []),
      lampiranPdf: List<String>.from(data['lampiranPdf'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "isi": isi,
      "tanggal": tanggal,
      "dibuatOleh": dibuatOleh,
      "lampiranGambar": lampiranGambar,
      "lampiranPdf": lampiranPdf,
    };
  }
}
