import 'package:cloud_firestore/cloud_firestore.dart';

class Rumah {
  final String alamat;

  Rumah({
    required this.alamat,
  });

  factory Rumah.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Rumah(
      alamat: data['alamat'],
    );
  }
}
