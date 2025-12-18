import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara_pintar/models/user_app_credential.dart';
import 'log_aktivitas_service.dart';

class ManajemenPenggunaService {
  ManajemenPenggunaService._();
  static final instance = ManajemenPenggunaService._();

  final _db = FirebaseFirestore.instance;
  final _collectionPath = 'user_credential';

  /// Generate username dari email (sebelum @)
  String _generateUsernameFromEmail(String email) {
    return email.split('@').first.toLowerCase();
  }

  /// Get current admin email untuk log aktivitas
  String _getCurrentActorEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? 'System';
  }

  /// CREATE Pengguna Baru (Admin tidak logout)
  /// Membuat user di Firebase Auth + Firestore dengan displayName
  Future<String> createManajemenPengguna({
    required String email,
    required String password,
    required String role,
  }) async {
    FirebaseApp? secondaryApp;
    try {
      // Gunakan secondary app agar admin tidak logout
      final existing = Firebase.apps.where((a) => a.name == 'SecondaryApp');
      secondaryApp = existing.isNotEmpty
          ? existing.first
          : await Firebase.initializeApp(
              name: 'SecondaryApp',
              options: Firebase.app().options,
            );

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final userCredential =
          await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final displayName = _generateUsernameFromEmail(email);

      // Update display name di Firebase Auth
      await userCredential.user!.updateDisplayName(displayName);

      // Simpan ke Firestore
      await _db.collection(_collectionPath).doc(uid).set(
            UserAppCredential(
              uid: uid,
              email: email,
              role: role,
            ).toFirestore(),
          );

      // Log aktivitas
      await LogAktivitasService.instance.createLogAktivitas(
        deskripsi:
            'Menambahkan pengguna baru: $email (role: $role, username: $displayName)',
        aktor: _getCurrentActorEmail(),
      );

      return uid;
    } catch (e) {
      throw Exception('Gagal membuat pengguna: $e');
    } finally {
      if (secondaryApp != null) {
        try {
          await secondaryApp.delete();
        } catch (_) {}
      }
    }
  }

  /// READ List semua pengguna
  Future<List<UserAppCredential>> getAllManajemenPengguna() async {
    try {
      final snapshot =
          await _db.collection(_collectionPath).orderBy('email').get();
      return snapshot.docs
          .map((doc) => UserAppCredential.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: $e');
    }
  }

  /// UPDATE Pengguna - update role dan sync displayName ke Firebase Auth
  Future<void> updateManajemenPengguna({
    required String uid,
    required String email,
    required String role,
  }) async {
    FirebaseApp? secondaryApp;
    try {
      // Ambil data lama untuk perbandingan log
      final oldDoc = await _db.collection(_collectionPath).doc(uid).get();
      final oldData = oldDoc.data() as Map<String, dynamic>? ?? {};
      final oldRole = oldData['role'] ?? 'warga';

      // Update di Firestore
      await _db.collection(_collectionPath).doc(uid).update({
        'email': email,
        'role': role,
      });

      // Sync displayName ke Firebase Auth
      final existing = Firebase.apps.where((a) => a.name == 'SecondaryApp');
      secondaryApp = existing.isNotEmpty
          ? existing.first
          : await Firebase.initializeApp(
              name: 'SecondaryApp',
              options: Firebase.app().options,
            );

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final displayName = _generateUsernameFromEmail(email);

      try {
        // Attempt to update display name (perlu user context atau token khusus)
        // Untuk sekarang, ini adalah placeholder - bisa diimplementasi via Cloud Functions
      } catch (_) {
        // Fallback: hanya update Firestore, displayName tetap
      }

      // Log aktivitas jika ada perubahan
      final changes = <String>[];
      if (oldRole != role) {
        changes.add('role: $oldRole → $role');
      }

      if (changes.isNotEmpty) {
        await LogAktivitasService.instance.createLogAktivitas(
          deskripsi: 'Memperbarui pengguna $email: ${changes.join(', ')}',
          aktor: _getCurrentActorEmail(),
        );
      }
    } catch (e) {
      throw Exception('Gagal mengupdate pengguna: $e');
    } finally {
      if (secondaryApp != null) {
        try {
          await secondaryApp.delete();
        } catch (_) {}
      }
    }
  }

  /// DELETE Pengguna - TIDAK DIIMPLEMENTASIKAN
  /// Per requirement, hanya ada Read, Create, Update
}
