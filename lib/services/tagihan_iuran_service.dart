import 'package:cloud_firestore/cloud_firestore.dart';

class TagihanIuranService {
  // Singleton
  TagihanIuranService._();

  static final TagihanIuranService instance = TagihanIuranService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "tagihan_iuran";


//   Future<String> createTagihan({
//     required String kategori,
//     required String tanggal,
// }) async {
//     final docRef = _db.collection(_collection).doc();
//     final data = {
//       "":
//     }
//
//     return
//   }

}