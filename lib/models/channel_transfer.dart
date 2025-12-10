import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelTransfer {
  final String id;
  final String nama;
  final String tipe;
  final String pemilik;
  final String nomorRekening;

  ChannelTransfer({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.pemilik,
    required this.nomorRekening,
  });

  factory ChannelTransfer.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChannelTransfer(
      id: doc.id,
      nama: data['nama'],
      tipe: data['tipe'],
      pemilik: data['pemilik'],
      nomorRekening: data['no_rek'],
    );
  }
}
