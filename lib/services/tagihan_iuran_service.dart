import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagihan_iuran.dart';
import 'log_aktivitas_service.dart';

class TagihanIuranService {
  // Singleton
  TagihanIuranService._();

  static final TagihanIuranService instance = TagihanIuranService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "tagihan_iuran";
  final _riwayatCollection = "riwayat_pembayaran";

  // CREATE - Buat tagihan untuk semua keluarga aktif
  Future<List<String>> createTagihanBulkKeluargaAktif({
    required String kategoriIuran,
    required String idKategoriIuran,
    required int nominal,
    required DateTime periode,
  }) async {
    final List<String> createdIds = [];

    try {
      print('DEBUG SERVICE: Fetching keluarga aktif...');

      // Ambil semua keluarga dengan domicileStatus "Aktif" dari collection 'warga'
      final keluargaSnapshot = await _db
          .collection('warga')
          .where('domicileStatus', isEqualTo: 'Aktif')
          .get();

      print(
          'DEBUG SERVICE: Found ${keluargaSnapshot.docs.length} keluarga aktif');

      if (keluargaSnapshot.docs.isEmpty) {
        throw Exception('Tidak ada keluarga dengan domicileStatus "Aktif"');
      }

      // Buat tagihan untuk setiap keluarga
      for (var keluargaDoc in keluargaSnapshot.docs) {
        final keluargaData = keluargaDoc.data();
        print(
            'DEBUG SERVICE: Creating tagihan for ${keluargaData['name'] ?? 'Unknown'}');

        final docRef = _db.collection(_collection).doc();
        final data = {
          "id_keluarga": keluargaDoc.id,
          "nama_keluarga": keluargaData['name'] ?? '',
          "alamat": keluargaData['family'] ??
              '', // Menggunakan 'family' sebagai alamat (nama keluarga/marga)
          "kategori_iuran": kategoriIuran,
          "id_kategori_iuran": idKategoriIuran,
          "nominal": nominal,
          "periode": Timestamp.fromDate(periode),
          "status_pembayaran": StatusPembayaran.belum.name,
          "status_keluarga": StatusKeluargaTagihan.aktif.name,
          "metode_pembayaran": null,
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        };

        await docRef.set(data);
        createdIds.add(docRef.id);
        print('DEBUG SERVICE: Created tagihan with ID: ${docRef.id}');
      }

      print('DEBUG SERVICE: Total created: ${createdIds.length}');
      return createdIds;
    } catch (e, stackTrace) {
      print('DEBUG SERVICE ERROR: $e');
      print('DEBUG SERVICE STACK: $stackTrace');
      throw Exception('Gagal membuat tagihan: $e');
    }
  }

  // READ - Ambil semua tagihan
  Future<List<TagihanIuran>> getAllTagihan() async {
    QuerySnapshot snapshot = await _db
        .collection(_collection)
        .orderBy('periode', descending: true)
        .get();

    List<TagihanIuran> tagihanList = snapshot.docs.map(
      (data) {
        return TagihanIuran.fromFirestore(data);
      },
    ).toList();

    return tagihanList;
  }

  // READ - Ambil tagihan dengan filter
  Future<List<TagihanIuran>> getTagihanWithFilter({
    StatusPembayaran? statusPembayaran,
    StatusKeluargaTagihan? statusKeluarga,
    String? namaKeluarga,
    String? kategoriIuran,
    DateTime? periode,
  }) async {
    Query query = _db.collection(_collection);

    // Filter by status pembayaran
    if (statusPembayaran != null) {
      query =
          query.where('status_pembayaran', isEqualTo: statusPembayaran.name);
    }

    // Filter by status keluarga
    if (statusKeluarga != null) {
      query = query.where('status_keluarga', isEqualTo: statusKeluarga.name);
    }

    // Filter by kategori iuran
    if (kategoriIuran != null && kategoriIuran.isNotEmpty) {
      query = query.where('kategori_iuran', isEqualTo: kategoriIuran);
    }

    // Filter by periode (bulan & tahun)
    if (periode != null) {
      // Ambil tanggal awal dan akhir bulan
      final startOfMonth = DateTime(periode.year, periode.month, 1);
      final endOfMonth =
          DateTime(periode.year, periode.month + 1, 0, 23, 59, 59);

      query = query.where('periode',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth));
      query = query.where('periode',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth));
    }

    query = query.orderBy('periode', descending: true);

    QuerySnapshot snapshot = await query.get();

    List<TagihanIuran> tagihanList = snapshot.docs.map(
      (data) {
        return TagihanIuran.fromFirestore(data);
      },
    ).toList();

    // Filter by nama keluarga (case insensitive)
    if (namaKeluarga != null && namaKeluarga.isNotEmpty) {
      tagihanList = tagihanList.where((tagihan) {
        return tagihan.namaKeluarga
            .toLowerCase()
            .contains(namaKeluarga.toLowerCase());
      }).toList();
    }

    return tagihanList;
  }

  // READ - Ambil tagihan by ID
  Future<TagihanIuran?> getTagihanById(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();

    if (!doc.exists) return null;

    return TagihanIuran.fromFirestore(doc);
  }

  // UPDATE - Update status pembayaran tagihan
  Future<void> updateStatusPembayaran({
    required String idTagihan,
    required StatusPembayaran status,
    String? metodePembayaran,
  }) async {
    final Map<String, dynamic> data = {
      "status_pembayaran": status.name,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (metodePembayaran != null) {
      data["metode_pembayaran"] = metodePembayaran;
    }

    await _db.collection(_collection).doc(idTagihan).update(data);
  }

  // CREATE - Tambah riwayat pembayaran (dari warga)
  Future<String> tambahRiwayatPembayaran({
    required String idTagihan,
    required String buktiUrl,
  }) async {
    final docRef = _db.collection(_riwayatCollection).doc();
    final data = {
      "id_tagihan": idTagihan,
      "status": StatusPembayaran.menunggu.name,
      "bukti_url": buktiUrl,
      "catatan": null,
      "tanggal": FieldValue.serverTimestamp(),
      "verifikator": null,
    };

    await docRef.set(data);

    // Update status tagihan menjadi menunggu
    await updateStatusPembayaran(
      idTagihan: idTagihan,
      status: StatusPembayaran.menunggu,
      metodePembayaran: "Transfer",
    );

    return docRef.id;
  }

  // UPDATE - Verifikasi pembayaran (setujui/tolak)
  Future<String> verifikasiPembayaran({
    required String idTagihan,
    required bool disetujui,
    required String catatan,
    required String verifikator,
    String? buktiUrl,
  }) async {
    final status =
        disetujui ? StatusPembayaran.diterima : StatusPembayaran.ditolak;

    // Tambah riwayat pembayaran baru
    final docRef = _db.collection(_riwayatCollection).doc();
    final data = {
      "id_tagihan": idTagihan,
      "status": status.name,
      "bukti_url": buktiUrl,
      "catatan": catatan,
      "tanggal": FieldValue.serverTimestamp(),
      "verifikator": verifikator,
    };

    await docRef.set(data);

    // Update status tagihan
    await updateStatusPembayaran(
      idTagihan: idTagihan,
      status: status,
    );

    return docRef.id;
  }

  // READ - Ambil riwayat pembayaran by tagihan ID
  // NOTE: Memerlukan composite index di Firestore:
  // Collection: riwayat_pembayaran
  // Fields: id_tagihan (Ascending), tanggal (Descending)
  Future<List<RiwayatPembayaran>> getRiwayatPembayaranByTagihanId(
      String idTagihan) async {
    QuerySnapshot snapshot = await _db
        .collection(_riwayatCollection)
        .where('id_tagihan', isEqualTo: idTagihan)
        .orderBy('tanggal', descending: true)
        .get();

    List<RiwayatPembayaran> riwayatList = snapshot.docs.map(
      (data) {
        return RiwayatPembayaran.fromFirestore(data);
      },
    ).toList();

    return riwayatList;
  }

  // READ - Ambil riwayat pembayaran terakhir (untuk ditampilkan di modal)
  // NOTE: Memerlukan composite index yang sama dengan method di atas
  Future<RiwayatPembayaran?> getLatestRiwayatPembayaran(
      String idTagihan) async {
    QuerySnapshot snapshot = await _db
        .collection(_riwayatCollection)
        .where('id_tagihan', isEqualTo: idTagihan)
        .orderBy('tanggal', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return RiwayatPembayaran.fromFirestore(snapshot.docs.first);
  }
}
