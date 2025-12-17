import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara_pintar/services/rumah_service.dart';
import 'package:jawara_pintar/services/user_credential_service.dart';
import 'package:jawara_pintar/services/user_profile_service.dart';

class AuthService {
  // Singleton
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Convert nama lengkap to username format
  /// - Remove whitespace
  /// - Convert to lowercase
  /// - Remove special characters (keep only alphanumeric)
  String _generateUsername(String namaLengkap) {
    return namaLengkap
        .trim() // Hapus whitespace di awal dan akhir
        .toLowerCase() // Convert ke lowercase
        .replaceAll(RegExp(r'\s+'), '') // Hapus semua whitespace
        .replaceAll(
            RegExp(r'[^a-z0-9]'), ''); // Hapus karakter selain huruf dan angka
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check user role
      final credential = await UserCredentialService.instance
          .getUserCredentialByUid(userCredential.user!.uid);

      if (credential == null) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'Data credential tidak ditemukan. Hubungi administrator.',
        };
      }

      // Only allow administrator to login
      if (credential.role != 'administrator') {
        await _auth.signOut();
        return {
          'success': false,
          'message':
              'Akses ditolak. Hanya administrator yang dapat login ke aplikasi ini.',
        };
      }

      return {
        'success': true,
        'message': 'Login berhasil',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
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

      // Generate username dari nama lengkap
      final String username = _generateUsername(namaLengkap);
      await cred.user!.updateDisplayName(username);

      String rumahPath;
      if (selectedRumahPath != null && selectedRumahPath.isNotEmpty) {
        // rumah yang sudah ada
        rumahPath = selectedRumahPath;
      } else {
        // rumah baru
        rumahPath = (await RumahService.instance.createRumah(
          alamat: alamatManual!,
        ))
            .path;
      }

      // Simpan profil user (statusKepemilikanRumah sekarang ada di user_profile)
      await UserProfileService.instance.createUserProfile(
        uid: uid,
        namaLengkap: namaLengkap,
        nik: nik,
        noTelepon: telp,
        jenisKelamin: jenisKelamin,
        statusKepemilikanRumah: statusRumah,
        rumahPath: rumahPath,
      );

      // Simpan user credential dengan role administrator (default untuk register)
      await UserCredentialService.instance.createUserCredential(
        uid: uid,
        email: email,
        role: 'administrator', // Default role untuk registrasi
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

      // Generate username dari nama baru
      final String username = _generateUsername(newName);
      await user.updateDisplayName(username);
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

  /// Change password untuk user yang sedang login
  /// Memerlukan password lama untuk verifikasi
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null || user.email == null) {
        return {
          'success': false,
          'message': 'Pengguna tidak ditemukan. Silakan login kembali.',
        };
      }

      // Re-authenticate user dengan password lama
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return {
        'success': true,
        'message': 'Password berhasil diubah.',
      };
    } on FirebaseAuthException catch (e) {
      // Handle berbagai error code dari Firebase
      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential' ||
          e.message?.contains('password is invalid') == true) {
        return {
          'success': false,
          'message': 'Password lama yang Anda masukkan salah.',
        };
      } else if (e.code == 'weak-password') {
        return {
          'success': false,
          'message': 'Password baru terlalu lemah. Minimal 6 karakter.',
        };
      } else if (e.code == 'requires-recent-login') {
        return {
          'success': false,
          'message': 'Sesi Anda telah berakhir. Silakan login kembali.',
        };
      } else if (e.code == 'user-not-found') {
        return {
          'success': false,
          'message': 'Akun tidak ditemukan. Silakan login kembali.',
        };
      }

      // Log error untuk debugging
      print('FirebaseAuthException: ${e.code} - ${e.message}');

      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    } catch (e) {
      print('Error changing password: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
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
