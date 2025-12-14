import 'package:cloud_firestore/cloud_firestore.dart';

class KegiatanModel {
  final String id;
  final String namaKegiatan;
  final String kategori;
  final String deskripsi;
  final String tanggal;
  final String lokasi;
  final String penanggungJawab;
  final String dibuatOleh;
  final int anggaran;

  KegiatanModel({
    required this.id,
    required this.namaKegiatan,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.penanggungJawab,
    required this.dibuatOleh,
    this.anggaran = 0,
  });

  factory KegiatanModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return KegiatanModel(
      id: doc.id,
      namaKegiatan: data['namaKegiatan'],
      kategori: data['kategori'],
      deskripsi: data['deskripsi'],
      tanggal: data['tanggal'],
      lokasi: data['lokasi'],
      penanggungJawab: data['penanggungJawab'],
      dibuatOleh: data['dibuatOleh'],
      anggaran: data['anggaran'] ?? 0,
    );
  }
}
