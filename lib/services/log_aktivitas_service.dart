import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/log_aktivitas.dart';

class LogAktivitasService {
  LogAktivitasService._();

  static final LogAktivitasService instance = LogAktivitasService._();
  final _db = FirebaseFirestore.instance;
  final _collection = "log_aktivitas";

  Future<String> createLogAktivitas({
    required String deskripsi,
    required String aktor,
  }) async {
    final docRef = _db.collection(_collection).doc();
    final data = {
      "deskripsi": deskripsi,
      "aktor": aktor,
      "waktu": FieldValue.serverTimestamp(),
    };
    await docRef.set(data);
    return docRef.id;
  }

  Future<List<LogAktivitas>> getAllLogAktivitas() async {
    QuerySnapshot logSnapshot =
        await _db.collection(_collection).orderBy('waktu', descending: true).get();

    List<LogAktivitas> logs = logSnapshot.docs.map(
      (data) {
        return LogAktivitas.fromFirestore(data);
      },
    ).toList();

    return logs;
  }

  Future<void> updateLogAktivitas({
    required String id,
    required Map<String, dynamic> logBaru,
  }) async {
    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...logBaru,
    };

    await _db.collection(_collection).doc(id).update(data);
  }

  Future<void> deleteLogAktivitas(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<List<LogAktivitas>> getLogAktivitasLimit({
    LogAktivitas? startAfter,
    required int limit,
  }) async {
    Query query = _db
        .collection(_collection)
        .orderBy('waktu', descending: true)
        .limit(limit);

    if (startAfter != null) {
      final docSnapshot =
          await _db.collection(_collection).doc(startAfter.id).get();
      query = query.startAfterDocument(docSnapshot);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs
        .map((doc) => LogAktivitas.fromFirestore(doc))
        .toList();
  }
}