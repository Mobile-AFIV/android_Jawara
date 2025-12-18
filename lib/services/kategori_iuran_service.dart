import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kategori_iuran.dart';
import 'log_aktivitas_service.dart';

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
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Menambahkan Kategori Iuran baru : $nama',
      aktor: 'System',
    );
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
    final docRef = _db.collection(_collection).doc(id);
    final oldDoc = await docRef.get();
    final oldData = oldDoc.data() ?? {};

    final String namaKategori = kategoriBaru['nama'] ?? oldData['nama'] ?? 'Unknown';

    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...kategoriBaru,
    };
  
    await _db.collection(_collection).doc(id).update(data);
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Mengubah Kategori Iuran dengan : $namaKategori diperbaruik',
      aktor: 'System',
    );
  }
}
