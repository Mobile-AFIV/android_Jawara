import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/models/rumah.dart';

class RumahService {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<Rumah?> getRumahByPath(String path) async {
    final DocumentSnapshot documentSnapshot = await instance.doc(path).get();

    if (!documentSnapshot.exists) return null;

    return Rumah.fromFirestore(documentSnapshot);
  }
}
