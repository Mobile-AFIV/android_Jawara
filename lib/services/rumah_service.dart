import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/models/rumah.dart';
import 'log_aktivitas_service.dart';

class RumahService {
  // Singleton
  RumahService._();
  static final RumahService instance = RumahService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Rumah?> getRumahByPath(String path) async {
    final DocumentSnapshot documentSnapshot = await _db.doc(path).get();

    if (!documentSnapshot.exists) return null;

    return Rumah.fromFirestore(documentSnapshot);
  }

  Future<DocumentReference> createRumah({
    required String alamat,
  }) async {
    final Map<String, dynamic> data = {
      "alamat": alamat,
    };
    final DocumentReference newRumahRef = _db.collection('rumah').doc();
    
    await newRumahRef.set(data);
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Menambahkan Rumah baru : $alamat',
      aktor: 'System',
    );
    return newRumahRef;
  }
}
