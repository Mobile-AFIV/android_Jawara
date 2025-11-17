import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'message': 'Login berhasil',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> updateUserDisplayName(String newName) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return {
          'success': false,
          'message': "Pengguna tidak ditemukan",
        };
      }

      await user.updateDisplayName(newName);
      await user.reload();

      return {
        'success': true,
        'message': 'Update berhasil',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    }
  }



  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-not-found':
        return 'Pengguna tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan';
      default:
        return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}
