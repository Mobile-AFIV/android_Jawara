import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara_pintar/services/rumah_service.dart';
import 'package:jawara_pintar/services/user_profile_service.dart';

class AuthService {
  // Singleton
  AuthService._();
  static final AuthService instance = AuthService._();

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

  Future<Map<String, dynamic>> register({
    required String namaLengkap,
    required String nik,
    required String email,
    required String telp,
    required String password,
    required String jenisKelamin,
    required String statusRumah,

    // Rumah: salah satu boleh null
    String? selectedRumahPath, // jika user pilih rumah dari dropdown
    String? alamatManual, // jika user isi alamat manual
  }) async {
    try {
      // buat akun auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = cred.user!.uid;
      await cred.user!.updateDisplayName(namaLengkap);

      String rumahPath;
      if (selectedRumahPath != null && selectedRumahPath.isNotEmpty) {
        // rumah yang sudah ada
        rumahPath = selectedRumahPath;
      } else {
        // rumah baru
        rumahPath = (await RumahService.instance.createRumah(
          alamat: alamatManual!,
          statusKepemilikan: statusRumah,
        )).path;
      }

      // Simpan profil user
      await UserProfileService.instance.createUserProfile(
        uid: uid,
        namaLengkap: namaLengkap,
        nik: nik,
        noTelepon: telp,
        jenisKelamin: jenisKelamin,
        statusKepemilikanRumah: statusRumah,
        rumahPath: rumahPath,
      );

      return {
        "success": true,
        "message": "Registrasi yang anda lakukan sukses",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "success": false,
        "message": _getErrorMessage(e),
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Terjadi kesalahan register: $e",
      };
    }
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
      case 'weak-password':
        return 'Password setidaknya ada 6 karakter';
      case 'email-already-in-use':
        return 'Email ini sudah pernah digunakan';
      default:
        return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}
