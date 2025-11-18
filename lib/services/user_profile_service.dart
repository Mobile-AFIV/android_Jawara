import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfileByUid(String uid) async {
    final QuerySnapshot querySnapshot = await instance
        .collection('user_profile')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return UserProfile.fromFirestore(querySnapshot.docs.first);
  }
}
