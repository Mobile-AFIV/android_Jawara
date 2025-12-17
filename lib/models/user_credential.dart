import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredential {
  final String uid;
  final String email;
  final String role; // 'administrator' atau 'warga'

  UserCredential({
    required this.uid,
    required this.email,
    required this.role,
  });

  // From Firestore
  factory UserCredential.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCredential(
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
  UserCredential copyWith({
    String? uid,
    String? email,
    String? role,
  }) {
    return UserCredential(
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
