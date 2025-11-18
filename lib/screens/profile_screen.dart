import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/rumah.dart';
import 'package:jawara_pintar/models/user_profile.dart';
import 'package:jawara_pintar/services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?> loadFullProfile(String uid) async {
    // Get Profil
    final UserProfile? profile =
        await UserProfileService().getUserProfileByUid(uid);
    if (profile == null) return null;

    // Get Rumah
    final DocumentSnapshot rumah = await profile.rumah.get();

    return {
      'profile': profile,
      'rumah': Rumah.fromFirestore(rumah),
    };
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: loadFullProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Profil tidak ditemukan"));
          }

          final UserProfile profile = snapshot.data!['profile'] as UserProfile;
          final Rumah rumah = snapshot.data!['rumah'] as Rumah;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username: ${currentUser.displayName}"),
                const SizedBox(height: 16),
                Text("Nama Lengkap: ${profile.namaLengkap}"),
                const SizedBox(height: 8),
                Text("Jenis Kelamin: ${profile.jenisKelamin}"),
                const SizedBox(height: 8),
                Text("NIK: ${profile.nik}"),
                const SizedBox(height: 8),
                Text("No Telepon: ${profile.noTelepon}"),
                const SizedBox(height: 16),
                Text("Alamat: ${rumah.alamat}"),
                const SizedBox(height: 8),
                Text("Status Kepemilikan: ${rumah.statusKepemilikan}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
