import 'package:cloud_firestore/cloud_firestore.dart';

class UserAppCredential {
  final String uid;
  final String email;
  final String role; // 'administrator' atau 'warga'

  UserAppCredential({
    required this.uid,
    required this.email,
    required this.role,
  });

  // From Firestore
  factory UserAppCredential.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserAppCredential(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'warga',
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
    };
  }

  // Copy with
  UserAppCredential copyWith({
    String? uid,
    String? email,
    String? role,
  }) {
    return UserAppCredential(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserCredential(uid: $uid, email: $email, role: $role)';
  }
}
