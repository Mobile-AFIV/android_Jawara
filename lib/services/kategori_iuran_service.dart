import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kategori_iuran.dart';

class KategoriIuranService {
  // Singleton
  KategoriIuranService._();

  static final KategoriIuranService instance = KategoriIuranService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "kategori_iuran";

  Future<String> createKategori({
    required String nama,
    required int nominal,
    required String jenisIuran,
  }) async {
    final docRef = _db.collection(_collection).doc();
    final data = {
      "nama": nama,
      "nominal": nominal,
      "jenis_iuran": jenisIuran,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
    await docRef.set(data);
    return docRef.id;
  }

  Future<List<KategoriIuran>> getAllKategori() async {
    QuerySnapshot categorySnapshot =
        await _db.collection("kategori_iuran").get();

    List<KategoriIuran> categories = categorySnapshot.docs.map(
      (data) {
        return KategoriIuran.fromFirestore(data);
      },
    ).toList();

    return categories;
  }

  Future<void> updateKategori({
    required String id,
    required Map<String, dynamic> kategoriBaru,
  }) async {
    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...kategoriBaru,
    };

    await _db.collection(_collection).doc(id).update(data);
  }
}
