import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengeluaran.dart';
import 'log_aktivitas_service.dart';

class PengeluaranService {
  // Singleton
  PengeluaranService._();

  static final PengeluaranService instance = PengeluaranService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "pengeluaran";

  // Create
  Future<String> createPengeluaran({
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
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Menambahkan Pengeluaran baru: $nama',
      aktor: 'System',
    );
    return docRef.id;
  }

  // Read All
  Future<List<Pengeluaran>> getAllPengeluaran() async {
    QuerySnapshot snapshot = await _db
        .collection(_collection)
        .orderBy('tanggal', descending: true)
        .get();

    List<Pengeluaran> pengeluaranList = snapshot.docs.map(
      (data) {
        return Pengeluaran.fromFirestore(data);
      },
    ).toList();

    return pengeluaranList;
  }

  // Read with Filter
  Future<List<Pengeluaran>> getPengeluaranWithFilter({
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

    List<Pengeluaran> pengeluaranList = snapshot.docs.map(
      (data) {
        return Pengeluaran.fromFirestore(data);
      },
    ).toList();

    // Filter by nama (case insensitive, karena Firestore tidak support case insensitive search)
    if (nama != null && nama.isNotEmpty) {
      pengeluaranList = pengeluaranList.where((pengeluaran) {
        return pengeluaran.nama.toLowerCase().contains(nama.toLowerCase());
      }).toList();
    }

    return pengeluaranList;
  }

  // Read by ID
  Future<Pengeluaran?> getPengeluaranById(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();
    
    if (!doc.exists) return null;
    
    return Pengeluaran.fromFirestore(doc);
  }

  // Update
  Future<void> updatePengeluaran({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> updateData = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...data,
    };

    final docRef = await _db.collection(_collection).doc(id).get();
    final oldData = docRef.data() ?? {};
    final String namaPengeluaran = data['nama'] ?? oldData['nama'] ?? 'Unknown';
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Memperbarui Pengeluaran: $namaPengeluaran',
      aktor: 'System',
    );
    await _db.collection(_collection).doc(id).update(updateData);
  }

  // Get all kategori pengeluaran
  List<String> getAllKategoriPengeluaran() {
    return [
      'Operasional RT/RW',
      'Kegiatan Sosial',
      'Pemeliharaan Fasilitas',
      'Pembangunan',
      'Kegiatan Warga',
      'Keamanan & Kebersihan',
      'Lain-lain',
    ];
  }
}
