import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  // Singleton
  UserProfileService._();
  static final UserProfileService instance = UserProfileService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfileByUid(String uid) async {
    final QuerySnapshot querySnapshot = await _db
        .collection('user_profile')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return UserProfile.fromFirestore(querySnapshot.docs.first);
  }

  Future<void> createUserProfile({
    required String uid,
    required String namaLengkap,
    required String nik,
    required String noTelepon,
    required String jenisKelamin,
    required String statusKepemilikanRumah,
    required String rumahPath,
  }) async {
    final DocumentReference rumahRef = _db.doc(rumahPath);

    final Map<String, dynamic> data = {
      "uid": uid,
      "namaLengkap": namaLengkap,
      "nik": nik,
      "noTelepon": noTelepon,
      "jenisKelamin": jenisKelamin,
      "statusKepemilikanRumah": statusKepemilikanRumah,
      "rumah": rumahRef, // DocumentReference
    };

    await _db.collection("user_profile").doc(uid).set(data);
  }
}
