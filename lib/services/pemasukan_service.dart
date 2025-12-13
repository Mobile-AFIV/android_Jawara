import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemasukan.dart';

class PemasukanService {
  // Singleton
  PemasukanService._();

  static final PemasukanService instance = PemasukanService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "pemasukan";

  // Create
  Future<String> createPemasukan({
    required String nama,
    required String kategori,
    required DateTime tanggal,
    required int nominal,
    required String verifikator,
    String? buktiUrl,
  }) async {
    final docRef = _db.collection(_collection).doc();
    final data = {
      "nama": nama,
      "kategori": kategori,
      "tanggal": Timestamp.fromDate(tanggal),
      "nominal": nominal,
      "verifikator": verifikator,
      "bukti_url": buktiUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
    await docRef.set(data);
    return docRef.id;
  }

  // Read All
  Future<List<Pemasukan>> getAllPemasukan() async {
    QuerySnapshot snapshot = await _db
        .collection(_collection)
        .orderBy('tanggal', descending: true)
        .get();

    List<Pemasukan> pemasukanList = snapshot.docs.map(
      (data) {
        return Pemasukan.fromFirestore(data);
      },
    ).toList();

    return pemasukanList;
  }

  // Read with Filter
  Future<List<Pemasukan>> getPemasukanWithFilter({
    String? nama,
    String? kategori,
    DateTime? dariTanggal,
    DateTime? sampaiTanggal,
  }) async {
    Query query = _db.collection(_collection);

    // Filter by kategori
    if (kategori != null && kategori.isNotEmpty) {
      query = query.where('kategori', isEqualTo: kategori);
    }

    // Filter by tanggal range
    if (dariTanggal != null) {
      query = query.where('tanggal',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dariTanggal));
    }

    if (sampaiTanggal != null) {
      // Tambahkan 1 hari untuk include sampai akhir hari
      final endDate = sampaiTanggal.add(const Duration(days: 1));
      query = query.where('tanggal',
          isLessThan: Timestamp.fromDate(endDate));
    }

    query = query.orderBy('tanggal', descending: true);

    QuerySnapshot snapshot = await query.get();

    List<Pemasukan> pemasukanList = snapshot.docs.map(
      (data) {
        return Pemasukan.fromFirestore(data);
      },
    ).toList();

    // Filter by nama (case insensitive, karena Firestore tidak support case insensitive search)
    if (nama != null && nama.isNotEmpty) {
      pemasukanList = pemasukanList.where((pemasukan) {
        return pemasukan.nama.toLowerCase().contains(nama.toLowerCase());
      }).toList();
    }

    return pemasukanList;
  }

  // Read by ID
  Future<Pemasukan?> getPemasukanById(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();
    
    if (!doc.exists) return null;
    
    return Pemasukan.fromFirestore(doc);
  }

  // Update
  Future<void> updatePemasukan({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> updateData = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...data,
    };

    await _db.collection(_collection).doc(id).update(updateData);
  }

  // Get all kategori pemasukan (gabungan dari kategori iuran + pemasukan lain)
  Future<List<String>> getAllKategoriPemasukan() async {
    // Kategori pemasukan lain yang sudah fixed
    final List<String> kategoriPemasukanLain = [
      'Donasi',
      'Dana Bantuan Pemerintah',
      'Sumbangan Swadaya',
      'Hasil Usaha Kampung',
      'Pendapatan Lainnya',
    ];

    // Ambil kategori iuran dari Firestore
    QuerySnapshot kategoriIuranSnapshot = 
        await _db.collection("kategori_iuran").get();
    
    List<String> kategoriIuran = kategoriIuranSnapshot.docs.map((doc) {
      return doc['nama'] as String;
    }).toList();

    // Gabungkan keduanya
    return [...kategoriIuran, ...kategoriPemasukanLain];
  }
}
