import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class ManajemenPenggunaService {
  ManajemenPenggunaService._();

  static final ManajemenPenggunaService instance = ManajemenPenggunaService._();

  final _db = FirebaseFirestore.instance;
  final _collectionPath = 'manajemen_pengguna';

  Future<String> createManajemenPengguna({
    required String namaLengkap,
    required String email,
    required String telp,
    required String password, 
    required String role,
    required bool isActive,
  }) async {
    final docRef = _db.collection(_collectionPath).doc();
    final data = {
      "nama": namaLengkap,
      "email": email,
      "role": role,
      "telp": telp,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
    await docRef.set(data);
    return docRef.id;
  }

  Future<List<Map<String, dynamic>>> getAllManajemenPengguna() async {
    QuerySnapshot penggunaSnapshot =
        await _db.collection(_collectionPath).get();

    List<UserProfile> listPengguna = penggunaSnapshot.docs.map(
      (data) {
        return UserProfile.fromFirestore(data);
      },
    ).toList();

    // Auth disini
    // ambil semua data akun email yang sudah register
    // -> List<Auth> = email && uid;
    List<String> listUid = ["qwouehiqwubey", "qwiudwqiuk"];
    
    List<Map<String, dynamic>> result = listUid.map((e) {

      UserProfile? pengguna;

      for (UserProfile p in listPengguna) {
        if (p.uid == e){
            pengguna = p;
            break;
        }
      }

      if (pengguna != null){
        return <String, dynamic>{
          "auth": e,
          "pengguna": pengguna,
        };
      }

      return <String, dynamic>{};
    }).toList();

    return result;
  }

  Future<void> updateManajemenPengguna({
    required String id,
    required Map<String, dynamic> penggunaBaru,
  }) async {
    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...penggunaBaru,
    };

    await _db.collection(_collectionPath).doc(id).update(data);
  }

  Future<void> deleteManajemenPengguna(String uid) async {
    await _db.collection(_collectionPath).doc(uid).delete();
  }
}