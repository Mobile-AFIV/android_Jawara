import 'package:cloud_firestore/cloud_firestore.dart';

class Rumah {
  final String alamat;
  final String statusKepemilikan;

  Rumah({
    required this.alamat,
    required this.statusKepemilikan,
  });

  factory Rumah.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Rumah(
      alamat: data['alamat'],
      statusKepemilikan: data['statusKepemilikan'],
    );
  }
}
