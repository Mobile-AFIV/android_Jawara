import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pesanWarga.dart';

class PesanWargaService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection("pesan_warga");

  // CREATE
  Future<void> tambahPesan(PesanWargaModel pesan) async {
    await _collection.add(pesan.toMap());
  }

  // READ (stream)
  Stream<List<PesanWargaModel>> getPesanWarga() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PesanWargaModel.fromFirestore(doc))
          .toList(),
    );
  }

  // DELETE
  Future<void> hapusPesan(String id) async {
    await _collection.doc(id).delete();
  }

  // UPDATE
  Future<void> updatePesan(PesanWargaModel pesan) async {
    await _collection.doc(pesan.id).update(pesan.toMap());
  }
}
