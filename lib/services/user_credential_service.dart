import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_pintar/models/user_app_credential.dart';

class UserCredentialService {
  // Singleton
  UserCredentialService._();
  static final UserCredentialService instance = UserCredentialService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'user_credential';

  // Create user credential
  Future<DocumentReference> createUserCredential({
    required String uid,
    required String email,
    required String role, // 'administrator' atau 'warga'
  }) async {
    final credential = UserAppCredential(
      uid: uid,
      email: email,
      role: role,
    );

    final docRef =
        await _firestore.collection(_collection).add(credential.toFirestore());

    return docRef;
  }

  // Get user credential by UID
  Future<UserAppCredential?> getUserCredentialByUid(String uid) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return UserAppCredential.fromFirestore(querySnapshot.docs.first);
  }

  // Get user credential by Email
  Future<UserAppCredential?> getUserCredentialByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return UserAppCredential.fromFirestore(querySnapshot.docs.first);
  }

  // Get all user credentials
  Future<List<UserAppCredential>> getAllUserCredentials() async {
    final querySnapshot = await _firestore.collection(_collection).get();

    return querySnapshot.docs
        .map((doc) => UserAppCredential.fromFirestore(doc))
        .toList();
  }

  // Get user credentials by role
  Future<List<UserAppCredential>> getUserCredentialsByRole(String role) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('role', isEqualTo: role)
        .get();

    return querySnapshot.docs
        .map((doc) => UserAppCredential.fromFirestore(doc))
        .toList();
  }

  // Update user role
  Future<void> updateUserRole({
    required String uid,
    required String newRole,
  }) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User credential not found');
    }

    await querySnapshot.docs.first.reference.update({
      'role': newRole,
    });
  }

  // Delete user credential
  Future<void> deleteUserCredential(String uid) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User credential not found');
    }

    await querySnapshot.docs.first.reference.delete();
  }

  // Check if user is administrator
  Future<bool> isAdministrator(String uid) async {
    final credential = await getUserCredentialByUid(uid);
    return credential?.role == 'administrator';
  }

  // Stream user credential
  Stream<UserAppCredential?> streamUserCredential(String uid) {
    return _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return UserAppCredential.fromFirestore(snapshot.docs.first);
    });
  }
}
