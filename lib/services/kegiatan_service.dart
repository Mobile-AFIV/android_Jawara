import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/models/kegiatan.dart';

class KegiatanService {
  static final KegiatanService instance = KegiatanService._();
  KegiatanService._();

  final _col = FirebaseFirestore.instance.collection('kegiatan');

  /// CREATE
  Future<void> create(KegiatanModel model) async {
    await _col.add({
      "namaKegiatan": model.namaKegiatan,
      "kategori": model.kategori,
      "deskripsi": model.deskripsi,
      "tanggal": model.tanggal,
      "lokasi": model.lokasi,
      "penanggungJawab": model.penanggungJawab,
      "dibuatOleh": model.dibuatOleh,
      "anggaran": model.anggaran,
    
    });
  }

  /// READ
  Stream<List<KegiatanModel>> getAll() {
    return _col.snapshots().map(
      (snap) => snap.docs.map((d) => KegiatanModel.fromFirestore(d)).toList(),
    );
  }

  /// UPDATE
  Future<void> update(String id, Map<String, dynamic> data) async {
    await _col.doc(id).update(data);
  }

  /// DELETE
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
